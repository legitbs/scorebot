class DashboardController < ApplicationController
  def index
    @instances = current_team.
      instances.
      joins(:service).
      where(services: {enabled: true})
  end
end
