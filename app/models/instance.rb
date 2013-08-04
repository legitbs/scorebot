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

  private
  def health_check_rounds
    @health_check_rounds ||= Round.limit(3).offset(1).order('created_at desc').reverse
  end
end
