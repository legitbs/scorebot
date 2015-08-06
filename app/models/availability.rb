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

  def fix_availability
    self.status = 0
    self.memo = "administratively fixed by legitbs <3 vito@legitbs.net"
    save
  end

  def decoded_dingus
    return nil if dingus.nil?
    @decoded_dingus ||= Dingus.new self.dingus, plaintext: true
  end

  def legit_dingus?
    return nil if decoded_dingus.nil?
    return false unless decoded_dingus.legit?
    return false unless decoded_dingus.team == instance.team
    return false unless ((created_at.to_i - 30)..(created_at.to_i + 30)).cover? decoded_dingus.to_h[:clocktime]

    return true
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

    StatsD.measure "#{instance.team.certname}.#{instance.service.name}.availability" do
      self.status = shell.status
    end

    self.memo = shell.output.force_encoding('binary')

    load_dinguses shell.output

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

    return { availability: as_json(only: :id, include: :penalties) }
  end

  def load_dinguses(memo)
    if has_token = /^!!legitbs-validate-token-hyekgiak (.+)$/.match(memo)
      self.token_string = has_token[1]
      candidate_token = Token.from_token_string self.token_string

      return false if candidate_token.nil?
      return false if candidate_token.instance != self.instance
      return false if candidate_token.expired?

      self.token = candidate_token
    end
  end

  def process_movements(_round)
    return if instance.team == Team.legitbs
    return unless instance.legitbs_instance.availabilities.find_by(round: round).healthy?

    flags = instance.flags.limit(Team.PARTICIPANT_COUNT)

    return distribute_parking(flags) if flags.count < Team.PARTICIPANT_COUNT
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
