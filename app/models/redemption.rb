class Redemption < ActiveRecord::Base
  belongs_to :team
  belongs_to :token, counter_cache: true
  belongs_to :round
  has_many :captures
  has_many :flags, through: :captures

  before_create :set_uuid
  after_create :log_spew

  def self.redeem_for(team, token_str)
    transaction do
      round = Round.current

      token = Token.from_token_string token_str
      raise NoTokenError.new if token.blank?
      raise OldTokenError.new unless token.eligible?
      raise SelfScoringError.new if team == token.instance.team

      begin
        candidate = create team: team, token: token, round: round
      rescue ActiveRecord::RecordNotUnique => e
        raise DuplicateTokenError.new
      rescue => e
        raise OtherTokenError.new e
      end

      return candidate
    end
  end

  class OtherTokenError < ArgumentError
    def initialize(e)
      correlation = SecureRandom.uuid
      Scorebot.log(
                   [correlation, 
                    e.class.name,
                    e.message, 
                    e.backtrace.join(', ')].
                   join('; '))
      super "some other error #{correlation}"
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

  class NoTokenError < ArgumentError
    def initialize
      super "Token doesn't exist"
    end
  end

  class SelfScoringError < ArgumentError
    def initialize
      super "Can't redeem your own tokens"
    end
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def log_spew
    Scorebot.log "Redeemed token #{token_id} from #{token.instance.team.name} #{token.instance.service.name} for team #{team.name} as #{uuid}"
  end
end
