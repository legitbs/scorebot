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
      if token.blank?
        team.increment! :notfound_ctr
        raise NoTokenError.new 
      end
      unless token.eligible?
        team.increment! :old_ctr
        raise OldTokenError.new 
      end
      if team == token.instance.team
        team.increment! :self_ctr
        raise SelfScoringError.new 
      end

      begin
        candidate = create team: team, token: token, round: round
      rescue ActiveRecord::RecordNotUnique => e
        team.dupe_ctr_defer ||= 0
        team.dupe_ctr_defer += 1
        raise DuplicateTokenError.new
      rescue => e
        team.other_ctr_defer ||= 0
        team.other_ctr_defer += 1
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

  def as_event_json
    { 
      redeeming_team: team.as_json,
      owned_team: token.instance.team.as_json,
      service: token.instance.service.as_json,
      redemption_stats: { 
        service: token.instance.service.total_redemptions,
        instance: token.instance.total_redemptions,
        redeeming_team: team.redemptions.count,
        all: Redemption.count,
      },
      redeemed_at_local: created_at.to_formatted_s(:ctf)
    }
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def log_spew
    Scorebot.log "Redeemed token #{token_id} from #{token.instance.team.name} #{token.instance.service.name} for team #{team.name} as #{uuid}"
  end
end
