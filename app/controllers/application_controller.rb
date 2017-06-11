class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_team, :is_legitbs?

  before_action :require_team, :check_rmp

  def client_cn
    request.env['HTTP_SSL_CLIENT_S_DN_CN']
  end

  def current_team
    if Rails.env.development?
      return @current_team ||= Team.legitbs
    end

    @current_team ||= Team.find_by uuid: client_cn
  end

  def is_legitbs?
    @is_legitbs ||= (current_team == Team.legitbs)
  end

  def require_team
    raise "Couldn't find cert for #{client_cn}" unless current_team
  end

  def check_rmp
    Rack::MiniProfiler.authorize_request if is_legitbs?
  end

  def require_legitbs
    raise ActionController::RoutingError.new('Not Found') unless is_legitbs?
  end
end
