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

  def legitbs_healthy?
    lbs = Team.legitbs
    lbs_inst = Instance.where(team_id: lbs.id, service_id: instance.service_id).first
    lbs_inst.healthy?
  end
end
