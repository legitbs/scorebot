class Team < ActiveRecord::Base
  before_create :set_uuid

  def as_ca_json
    {
      teamname: name,
      uuid: uuid,
      certname: certname
    }
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
