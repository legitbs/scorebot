class Token < ActiveRecord::Base
  include BCrypt
  belongs_to :instance
  belongs_to :round
  has_many :redemptions

  validates :instance, presence: true
  validates :round, presence: true

  before_create :set_keys

  # how many rounds do tokens last after deposit?
  EXPIRATION = 2

  def to_token_string
    key.chars.zip(@secret.chars).join
  end

  def self.from_token_string(token_string)
    begin
      key, secret = token_string.chars.each_slice(2).to_a.transpose.map(&:join)
      candidate = self.where(key: key).first
    rescue
      return nil
    end

    return nil unless candidate && (candidate.secret == secret)
    
    return candidate
  end

  def self.expiring
    r = Round.order('created_at desc').offset(EXPIRATION + 1).first
    return [] if r.nil?
    r.tokens
  end

  def self.live
    r = Round.order('created_at desc').offset(EXPIRATION + 1).first
    self.where('round_id > ?', r.id)
  end

  def eligible?
    Round.since(round) <= EXPIRATION
  end

  def secret
    Password.new self.digest
  end

  def deposit
    service_name = instance.service.name
    team_address = instance.team.address
    begin
      shell = ShellProcess.
        new(
            Rails.root.join('scripts', 'deposit'),
            instance.team.joe_name,
            service_name,
            to_token_string
            )

      self.status = shell.status
      self.memo = shell.output
    rescue => e
      Scorebot.log "serious deposit issue :( #{e.inspect}"
      self.status = -420
      self.memo = e
    end

    save

    Scorebot.log "deposit status #{status}"
    Scorebot.log memo
  end

  def process_redemptions(round)
    capture_count = redemptions.length
    return if capture_count == 0

    flags_to_distribute = instance.team.flags.limit 19

    each_team_gets = flags_to_distribute.length / capture_count
    floor_flags = flags_to_distribute.length % capture_count


    floor_flags.times do 
      flag = flags_to_distribute.pop
      flag.team = Team.legitbs
      flag.save
    end

    redemptions.each do |r|
      Scorebot.log "Giving #{each_team_gets} flags from #{r.token.instance.team.name} #{r.token.instance.service.name} to #{r.team.name}"
      each_team_gets.times do |g|
        capture = r.captures.build
        captured_flag = flags_to_distribute.pop
        capture.flag = captured_flag
        capture.round = round
        capture.save
      end
    end

    raise "didn't distribute enough flags, wtf" unless flags_to_distribute.empty?
  end

  private
  def set_keys
    self.key = random_dingus
    @secret = random_dingus
    self.digest = Password.create @secret, cost: 7
  end

  def random_dingus
    radix = 62
    max_len = 13
    extender = radix ** (max_len - 1)
    range = (radix ** max_len) - extender
    random = SecureRandom.random_number(range)
    (extender + random).base62_encode
  end
end
