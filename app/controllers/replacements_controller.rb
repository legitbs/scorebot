class ReplacementsController < ApplicationController
  def index
    @services = Service.enabled.all
    @teams = Team.order(certname: :asc).all

    @filters = {}
    @filters[:team_id] = params[:team_id].to_i if params[:team_id]
    @filters[:service_id] = Service.enabled.find(params[:service_id]).id if params[:service_id]

    per_page = 50

    @page = (params[:page] || 1).to_i
    @skip = (@page - 1) * per_page

    @replacements = Replacement.
                      where(@filters).
                      limit(50).
                      offset(@skip).
                      order(created_at: :desc).
                      joins(:team, :service).
                      all
  end

  def show
  end

  def new
    @services = Service.enabled.all
    @replacement = current_team.replacements.new
  end

  def create
    @service = Service.enabled.find(replacement_params[:service_id])
    @services = Service.enabled.all

    @replacement = current_team.replacements.
                     new(file: replacement_params[:file],
                         service: @service,
                         round: Round.current)
    begin
      if @replacement.save
        return redirect_to replacement_path(@replacement.id),
                           notice: "Replaced #{@service.name}"
      end
    rescue PG::UniqueViolation => e
      @replacement.errors.add :base, "already replaced this round"
    rescue => e
      @replacement.errors.add :base, "problem dog: #{e.message}"
    end

    render action: 'new'
  end

  private
  def replacement_params
    params.
      require(:replacement).
      permit(:service_id, :file)
  end
end
