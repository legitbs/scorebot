class AvailabilityCheck
  def initialize(service)
    @service = service
  end

  def instances
    @service.instances
  end
  
  def lbs_instance
    @lbs_instance ||= instances.where(team_id: Team.legitbs.id).first
  end

  def non_lbs_instances
    @non_lbs_instances ||= instances.where('team_id != ?', Team.legitbs.id)
  end

  def check_all_instances
    @lbs_check = lbs_instance.check_availability
    @non_lbs_checks = non_lbs_instances.
      map{|i| i.check_availability }
  end

  def distribute_flags
    return unless @lbs_check.healthy?

    @non_lbs_checks.reject(&:healthy?).each(&:distribute!)
  end
end
