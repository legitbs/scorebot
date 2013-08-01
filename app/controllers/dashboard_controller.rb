class DashboardController < ApplicationController
  def index
    @instances = current_team.
      instances.
      joins(:services).
      where(services: {enabled: true})
  end
end
