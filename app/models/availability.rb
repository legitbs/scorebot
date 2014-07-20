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

end
