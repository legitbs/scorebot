class AvailabilityCheck  
  WORKERS = 20
  INITIAL_TIMING = 4 * 60

  attr_accessor :timing_history
  attr_accessor :deadline

  def self.for_service(service)
    @@cache ||= Hash.new
    @@cache[service] ||= new service
  end

  def initialize(service)
    @service = service
    self.timing_history = [INITIAL_TIMING]
    @history_lock = Mutex.new
  end

  def timing_average
    timing_history.sum.to_f / timing_history.length
  end

  def gonna_run_long?
    Time.now.to_f + timing_average >= deadline.to_f
  end

  def schedule!
    remaining = deadline.to_f - Time.now.to_f

    # skew earlier
    start_before = remaining - (30 + timing_average)

    wait = rand(start_before)

    @thread = Thread.new do
      chill wait
      clock = Time.now.to_f
      check_all_instances
      duration = Time.now.to_f - clock

      @history_lock.synchronize do
        timing_history << duration
      end
    end

    wait
  end

  def join
    return unless defined? @thread
    @thread.join
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
    @lbs_check.save

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

          l "#{ instance.service.name } #{instance.team.certname} checking"

          av = instance.check_availability round
          l "#{ instance.service.name } #{instance.team.certname} status #{av.status}"
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

  private
  def chill(duration)
    schedule = Time.now.to_f + duration
    while Time.now.to_f < duration
      sleep 0.1
    end
  end

  def l(str)
    Scorebot.log str
  end
end
