class ReplacementsController < ApplicationController
  def index
    @services = Service.live.all
    @teams = Team.all
  end

  def show
  end

  def new
  end
end
