class Team < ActiveRecord::Base
  has_many :redemptions
  has_many :flags
  has_many :captures, through: :redemptions
  has_many :instances
  before_create :set_uuid

  def as_ca_json
    {
      teamname: name,
      uuid: uuid,
      certname: certname
    }
  end

  def self.legitbs
    @@legitbs ||= find_by uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86"
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
