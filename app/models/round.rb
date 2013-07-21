class Round < ActiveRecord::Base
  has_many :availabilities
  has_many :tokens
  has_many :redemptions

  def self.current
    order('created_at desc').first
  end

  def self.since(round)
    where('created_at > ?', round.created_at).size
  end

  def availability_checks_done?
    !availabilities.reload.empty?
  end

  def check_availability
    return if availability_checks_done?
    Service.all.each do |s|
      s.transaction do
        check = AvailabilityCheck.new s
        check.check_all_instances
        check.distribute_flags
      end
    end
  end
end
