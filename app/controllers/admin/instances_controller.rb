class Admin::InstancesController < Admin::BaseController
  def index
    @instances = Instance.order(team_id: :asc, service_id: :asc)
    @teams = Team.order(id: :asc)
    @services = Service.order(id: :asc)
  end

  def show
    return redirect_instance_find if params[:id] == '0'
    @instance = Instance.find params[:id]
  end

  private
  def redirect_instance_find
    @instance = Instance.find_by(service_id: params[:service],
                                 team_id: params[:team])
    redirect_to id: @instance.id, status: :found
  end
end
