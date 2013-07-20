class Availability < ActiveRecord::Base
  belongs_to :instance
  belongs_to :round

  def self.check(instance)
    candidate = new instance: instance
    candidate.check
    candidate.save
    return candidate
  end

  def check
    service_name = instance.service.name
    team_address = instance.team.address

    shell = ShellProcess.
      new(
          Rails.root.join('scripts', service_name, 'availability'),
          team_address
          )
    
    self.status = shell.status
    self.memo = shell.output
  end

  def healthy?
    status == 0
  end
end
