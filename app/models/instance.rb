class Instance < ActiveRecord::Base
  belongs_to :team
  belongs_to :service
  
  has_many :tokens
  has_many :redemptions, through: :tokens
  
  has_many :availabilities

  def check_availability
    round = Round.current
    availability = Availability.check self

    return if availability.healthy?

    other_teams = Team.where('id != ?', team_id)
    flags = Flag.where(team_id: team_id).limit(19)
    
    return park(flags) if other_teams.length != flags

    other_teams.each do |t|
      f = flags.pop
      f.team = t
      f.save
    end
  end

  private
  def park(flags)
    flags.each do |f|
      f.team = Team.legitbs
      f.save
    end
  end
end
