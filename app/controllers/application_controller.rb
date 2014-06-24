class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_team, :is_legitbs?

  def client_cn
    request.env['HTTP_CLIENT_CN']
  end

  def current_team
    unless Rails.env.production?
      return Team.legitbs
    end
    
    @current_team ||= Team.find_by uuid: client_cn
  end

  def is_legitbs?
    current_team == Team.legitbs
  end

  def require_legitbs
    raise ActionController::RoutingError.new('Not Found') unless is_legitbs?
  end
end
