class Admin::AvailabilitiesController < Admin::BaseController
  def index
    @oof = (params[:offset] || 0).to_i

    @availabilities = Availability.
                        order(created_at: :desc).
                        limit(200).
                        offset(@oof).
                        all
  end

  def show
    @availability = Availability.find params[:id]
  end
end
