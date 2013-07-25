class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_team

  def client_cn
    request.env['HTTP_CLIENT_CN']
  end

  def current_team
    if Rails.env.development?
      return Team.first
    end
    
    @current_team ||= Team.find_by uuid: client_cn
  end
end
