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
      next unless i.service.enabled
      new_tokens << Token.create(
                                 instance: i,
                                 round: self
                                 )
    end
    Stats.time 'all_deposits' do
      new_tokens.each(&:deposit)
    end
  end

  def finalize!
    enabled_services = Service.enabled.all
    self.distribution = enabled_services.map do |service|
      f = RoundFinalizer.new self, service
      f.movements

      f.as_metadata_json
    end.to_json

    store_signature

    save!

    Event.new('round_finish', event_payload).publish!
  end

  def add_nonce
    self.nonce = SecureRandom.uuid
  end

  def store_signature
    self.payload = Team.for_scoreboard.to_json
    self.signature = OpenSSL::HMAC.hexdigest(
                                        OpenSSL::Digest::SHA1.new,
                                        self.nonce,
                                        payload.to_json
                                        )
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
 
    return Token.where(id: nil) if expiring_round.nil?

    expiring_round.tokens
  end

  def event_payload
    prev = Round.where('id < ?', id).order(id: :desc).take
    prev_payload = prev.try(:payload) || []
    prev_places = prev_payload.map{ |e| e['name'] }
    now_places = payload.map{ |e| e['name'] }

    places_changed = prev_places != now_places

    { 
      payload: payload,
      previous_payload: prev_payload,
      places_changed: places_changed
    }
  end
end
