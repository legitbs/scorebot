class Instance < ActiveRecord::Base
  belongs_to :team
  belongs_to :service
  
  has_many :tokens
  has_many :redemptions, through: :tokens
  
  has_many :availabilities

  def check_availability
    round = Round.current
    return if availabilities.where(round_id: round).size != 0
    availability = Availability.check self
  end
end
