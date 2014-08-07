class Admin::InstancesController < Admin::BaseController
  def index
    @instances = Instance.order(team_id: :asc, service_id: :asc)
    @teams = Team.order(id: :asc)
    @services = Service.order(id: :asc)
  end

  def show
    @instance = Instance.find params[:id]
  end
end
