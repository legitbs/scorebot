class Admin::TeamsController < Admin::BaseController
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

    @team = Team.find params[:id]
    @services = Service.order(name: :asc)
    @rounds = Round.order(id: :desc).limit(@round_limit)
  end
end
