class Token < ActiveRecord::Base
  include BCrypt
  belongs_to :instance
  belongs_to :round

  validates :instance, presence: true
  validates :round, presence: true

  before_create :set_keys

  def to_token_string
    key.chars.zip(@secret.chars).join
  end

  def self.from_token_string(token_string)
    key, secret = token_string.chars.each_slice(2).to_a.transpose.map(&:join)
    candidate = self.where(key: key).first

    return nil unless candidate.secret == secret
    
    return candidate
  end

  def secret
    Password.new self.digest
  end

  private
  def set_keys
    self.key = random_dingus
    @secret = random_dingus
    self.digest = Password.create @secret, cost: 7
  end

  def random_dingus
    extender = 36 ** 25
    random = SecureRandom.random_number(36**24)
    (extender + random).to_s(36)
  end
end
