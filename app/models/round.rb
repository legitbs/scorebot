class Round < ActiveRecord::Base
  has_many :availabilities
  has_many :tokens
  has_many :redemptions

  ROUND_LENGTH = 5.minutes

  before_create :add_nonce

  def self.current
    where('ended_at is null', Time.now).order('created_at desc').first
  end

  def self.since(round)
    where('created_at > ?', round.created_at).size
  end

  def availability_checks_done?
    !availabilities.reload.empty?
  end

  def commence!
    round_timer = Timer.round
    round_timer.ending = Time.now + ROUND_LENGTH
    round_timer.save

    # distribute tokens
    new_tokens = []
    Instance.find_each do |i|
      new_tokens << Token.create(
                                 instance: i,
                                 round: self
                                 )
    end
    new_tokens.each(&:deposit)
  end

  def finalize!
    self.distribution = Service.enabled.map do |service|
      f = RoundFinalizer.new self, service
      f.movements
    end.to_json

    store_signature
  end

  def add_nonce
    self.nonce = SecureRandom.uuid
  end

  def store_signature
    payload = Team.for_scoreboard.to_json
    signature = OpenSSL::HMAC.hexdigest(
                                        OpenSSL::Digest::SHA1.new,
                                        self.nonce,
                                        payload
                                        )
    update_attributes payload: payload, signature: signature
  end

  def qr_signature
    "legitbs-2014-round-#{id}-#{self.signature}"
  end

  def qr
    Pngqr.encode qr_signature, scale: 9
  end

  def expiring_tokens
    expiring_round = self.class.
      where('id < ?', id).
      limit(Token::EXPIRATION + 1).
      order(id: :desc).
      last

    expiring_round.tokens
  end
end
