class Token < ActiveRecord::Base
  include BCrypt
  belongs_to :team
  belongs_to :service

  before_create :set_keys

  def to_token_string
    key.chars.zip(@secret.chars).join
  end

  def self.from_token_string(token_string)
    key, secret = token.chars.each_slice(2).to_a.transpose.map(&:join)
    candidate = self.where(key: key)

    return nil unless candidate.secret == secret
    
    return candidate
  end

  def secret
    Password.new self.digest
  end

  private
  def set_keys
    self.key = SecureRandom.random_number(2**128).to_s(36)
    @secret = SecureRandom.random_number(2**128).to_s(36)
    self.digest = Password.create @secret, cost: 7
  end
end
