class Team < ActiveRecord::Base
  before_create :set_uuid

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
