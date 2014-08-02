class Token < ActiveRecord::Base
  include BCrypt
  belongs_to :instance
  belongs_to :round
  has_many :redemptions
  has_many :captures, through: :redemptions

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
      key, secret = token_split token_string
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
    given_tok = to_token_string
    round_num = round.id
    begin
      shell = ShellProcess.
        new(
            Rails.root.join('scripts', service_name, 'deposit'),
            team_address,
            given_tok,
            round_num
            )

      self.status = shell.status
      self.memo = shell.output

      check_token_replacement

    rescue => e
      Scorebot.log "serious deposit issue :( #{e.inspect}"
      self.status = -420
      self.memo = e.to_s
    end

    save

    Scorebot.log "deposit status #{status}"
    Scorebot.log memo
  end

  def as_movement_json
    return { token: { id: id, secure: true } } if redemptions.empty?

    return { token: { 
        id: id,
        redemptions: redemptions.as_json(only: %i{ id uuid }),
        captures: captures.as_json
    } }
  end

  private
  def check_token_replacement
    return unless has_replaced_token = /^!!legitbs-replace-token (.+)$/.match(memo)

    self.key, @secret = token_split has_replaced_token[1]
    set_digest
  end

  def set_keys
    self.key = random_dingus unless self.key
    @secret = random_dingus unless @secret
    set_digest
  end

  def set_digest
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

  def token_split(token_string)
    self.class.token_split token_string
  end

  def self.token_split(token_string)
    token_string.chars.each_slice(2).to_a.transpose.map(&:join)
  rescue IndexError
    ['', '']
  end
end
