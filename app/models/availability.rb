class Availability < ActiveRecord::Base
  belongs_to :instance
  belongs_to :round

  def self.check(instance, round)
    candidate = new instance: instance, round: round
    candidate.check
    return candidate
  end

  def check
    service_name = instance.service.name
    team_address = instance.team.address

    script = Rails.root.join('scripts', service_name, 'availability')

    Dir.chdir File.dirname script
    shell = ShellProcess.
      new(
          script,
          team_address
          )
    
    self.status = shell.status
    self.memo = shell.output

    self
  end

  def healthy?
    status == 0
  end

  def distribute!
    flags = instance.team.flags.limit(19)

    return distribute_parking(flags) if flags.count < 19
    return distribute_everywhere(flags)
  end

  private
  def distribute_everywhere(flags)
    teams = Team.where('id != ? and id != ?', 
                       Team.legitbs.id, 
                       instance.team.id)
    flags.each do |f|
      t = teams.pop
      f.team = t
      f.save
    end
  end

  def distribute_parking(flags)
    flags.each do |f|
      f.team = Team.legitbs
      f.save
    end
  end
end
