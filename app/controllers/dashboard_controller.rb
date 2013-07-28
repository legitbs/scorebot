class DashboardController < ApplicationController
  def index
    @instances = current_team.instances
  end
end
