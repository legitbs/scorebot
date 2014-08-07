class Admin::TeamsController < Admin::BaseController
  def index
    @teams = Team.order(id: :asc)
  end

  def show
    @team = Team.find params[:id]
  end
end
