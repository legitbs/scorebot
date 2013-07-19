class Redemption < ActiveRecord::Base
  belongs_to :team
  belongs_to :token
  belongs_to :round
  has_many :captures
  has_many :flags, through: :captures

  def self.redeem_for(team, token_str)
    transaction do
      round = Round.current

      token = Token.from_token_string token_str
      raise OldTokenError.new unless token.eligible?

      begin
        candidate = create team: team, token: token
      rescue ActiveRecord::RecordNotUnique => e
        raise DuplicateTokenError.new
      end

      return candidate
    end
  end

  class DuplicateTokenError < ArgumentError
    def initialize
      super "Already redeemed that token"
    end
  end

  class OldTokenError < ArgumentError
    def initialize
      super "Token too old"
    end
  end
end
