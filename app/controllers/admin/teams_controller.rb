class Admin::TeamsController < Admin::BaseController
  helper_method :team
  def index
    case params[:order]
    when 'alpha'
      @teams = Team.order(name: :asc)
    when 'winning'
      @teams = Team.all.sort_by{ |t| - t.flags.count }
    else
      @teams = Team.order(id: :asc)
    end
  end

  def show
    @round_limit = params[:limit] || 24

    team
    @services = Service.order(name: :asc)
    @rounds = Round.order(id: :desc).limit(@round_limit)
  end

  def edit
  end

  def update
    team.update_attributes! team_params
    redirect_to admin_team_path team
  end

  private
  def team
    @team ||= Team.find params[:id]
  end

  def team_params
    params.require(:team).permit(:display).tap do |tp|
      tp[:display] = nil if tp[:display].blank?
    end
  end
end
