class Admin::AvailabilitiesController < Admin::BaseController
  def index
    @availabilities = Availability.order(created_at: :desc).limit(Team.count * Service.count)
  end

  def show
    @availability = Availability.find params[:id]
  end
end
