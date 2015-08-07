class Admin::ServicesController < Admin::BaseController
  helper_method :services, :service
  def index
  end

  def show

  end

  def edit
  end

  private
  def services
    @services ||= Service.order(name: :asc)
  end

  def service
    @service ||= Service.find params[:id]
  end

  def service_params
    params.require(:service).permit(:enabled)
  end
end