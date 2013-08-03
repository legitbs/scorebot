class AvailabilityCheck  
  WORKERS = 20

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
    @non_lbs_instances ||= instances.where('team_id != ?', Team.legitbs.id).includes(:service, :team)
  end

  def check_all_instances
    return unless @service.enabled
    
    @lbs_check = lbs_instance.check_availability Round.current

    @non_lbs_checks = process_instance_queue
  end

  def process_instance_queue
    queue = non_lbs_instances.shuffle
    queue_mutex = Mutex.new

    results = []
    result_mutex = Mutex.new

    round = Round.current

    threads = 1.upto(WORKERS).map do
      Thread.new do
        loop do
          instance = queue_mutex.synchronize do
            queue.shift
          end
          
          break if instance.nil?

          av = instance.check_availability round

          result_mutex.synchronize do
            results.push av
          end
        end
      end
    end

    threads.each {|t| t.join }
    
    Availability.transaction do
      results.each(&:save)
    end

    results
  end

  def distribute_flags
    return unless @service.enabled
    return unless @lbs_check.healthy?

    @non_lbs_checks.reject(&:healthy?).each(&:distribute!)
  end
end
