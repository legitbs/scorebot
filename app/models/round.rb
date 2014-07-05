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

  def check_availability
    return if availability_checks_done?
    Service.where(enabled: true).find_each do |s|
      s.transaction do
        check = AvailabilityCheck.new s
        check.check_all_instances
        check.distribute_flags
      end
    end
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
    # process redemptions
    Token.expiring.each do |t|
      t.process_redemptions self
    end

    Flag.reallocate self
    store_signature
  end

  def add_nonce
    self.nonce = SecureRandom.uuid
  end

  def store_signature
    self.payload = Team.for_scoreboard.to_json
    self.signature = OpenSSL::HMAC.hexdigest(
                                             OpenSSL::Digest::SHA1.new,
                                             self.nonce,
                                             self.payload.to_json
                                             )
  end

  def qr_signature
    "legitbs-2014-round-#{id}-#{signature}"
  end
end
