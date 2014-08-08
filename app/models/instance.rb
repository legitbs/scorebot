class Instance < ActiveRecord::Base
  belongs_to :team
  belongs_to :service
  
  has_many :tokens
  has_many :redemptions, through: :tokens
  
  has_many :availabilities

  def check_availability(round)
    availability = Availability.check self, round
  end

  def owned_check
    @owned_check ||= health_check_rounds.map do |r| 
      redemptions.where(round: r).first
    end
  end

  def uptime_check
    @uptime_check ||= health_check_rounds.map do |r| 
      availabilities.where(round: r, status: 0).first
    end
  end

  def total_redemptions
    tokens.sum(:redemptions_count)
  end

  def flags
    Flag.where(team_id: team.id, service_id: service.id)
  end

  def legitbs_instance
    Instance.find_by(team: Team.legitbs, service_id: service.id)
  end

  private
  def health_check_rounds
    @health_check_rounds ||= Round.limit(3).offset(1).order('created_at desc').reverse
  end
end
