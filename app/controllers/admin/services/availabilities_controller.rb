class Admin::Services::AvailabilitiesController < Admin::BaseController
  helper_method :service

  def index
    ordered_rounds = Round.order(id: :desc)
    if params[:rounds] == 'all'
      @rounds = ordered_rounds.all
    else
      @rounds = ordered_rounds.limit 25
    end

    @instances = service.instances
    availability_arr = Availability.
                       where(round_id: @rounds.map(&:id), instance_id: @instances).
                       order(round_id: :desc).
                       joins(:instance)

    @teams = Team.order(id: :asc).all

    @availabilities_rounds = Hash.new()
    availability_arr.each do |av|
      @availabilities_rounds[av.round_id] ||= {  }
      @availabilities_rounds[av.round_id][av.instance.team_id] = av
    end
  end

  private
  def service
    @service ||= Service.find params[:service_id]
  end
end
