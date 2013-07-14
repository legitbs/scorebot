class Availability < ActiveRecord::Base
  belongs_to :instance
  belongs_to :round

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
end
