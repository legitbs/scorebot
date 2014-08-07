class Availability < ActiveRecord::Base
  belongs_to :instance
  belongs_to :round
  belongs_to :token
  scope :failed, -> { where.not(status: 0) }
  has_many :penalties

  def self.check(instance, round)
    candidate = new instance: instance, round: round
    candidate.check
    return candidate
  end

  def check
    service_name = instance.service.name
    team_address = instance.team.address

    dir = "/home/scorebot/scripts/#{service_name}"
    script = 'availability'

    shell = ShellProcess.
      new(
          dir,
          script,
          team_address
          )
    
    Stats.time "#{instance.team.certname}.#{instance.service.name}.availability" do
      self.status = shell.status
    end
    self.memo = shell.output
    load_dinguses

    if self.token_string and !self.token
      self.status = 420
    end

    self
  end

  def healthy?
    status == 0
  end

  def as_movement_json
    return { availability: { id: id, healthy: true } } if healthy?

    return as_json include_root: true, only: %i{ id penalties }
  end

  def load_dinguses
    if has_token = /^!!legitbs-validate-token (.+)$/.match(memo)
      self.token_string = has_token[1]
      candidate_token = Token.from_token_string self.token_string

      return false if candidate_token.instance != self.instance
      return false if candidate_token.expired?

      self.token = candidate_token
    end
    
    if has_dingus = /^!!legitbs-validate-dev-ctf (.+)$/.match(memo)
      self.dingus = Base64.decode64 has_dingus[1]
    end
  end

  def process_movements(_round)
    flags = instance.team.flags.limit(19)

    return distribute_parking(flags) if flags.count < 19
    return distribute_everywhere(flags)
  end

  private
  def distribute_everywhere(flags)
    teams = Team.where('id != ? and id != ?', 
                       Team.legitbs.id, 
                       instance.team.id).to_a

    Scorebot.log "reallocating #{flags.length} from #{instance.team.name} #{instance.service.name} flags to #{teams.map(&:certname)} teams"

    flags.zip(teams) do |f, t|
      break if t.nil?
      f.team = t
      f.save!
      penalties.create team_id: t.id, flag_id: f.id
    end
  end

  def distribute_parking(flags)
    flags.each do |f|
      f.team = Team.legitbs
      f.save!
      penalties.create team_id: Team.legitbs.id, flag_id: f.id
    end
  end
end
