class Availability < ActiveRecord::Base
  belongs_to :instance
  belongs_to :round
  belongs_to :token

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
    load_dinguses

    self
  end

  def healthy?
    status == 0
  end


  def load_dinguses
    if has_token = /^!!legitbs-validate-token (.+)$/.match(memo)
      self.token_string = has_token[1]
      self.token = Token.from_token_string self.token_string
    end
    
    if has_dingus = /^!!legitbs-validate-dev-ctf (.+)$/.match(memo)
      self.dingus = Base64.decode64 has_dingus[1]
    end
  end
end
