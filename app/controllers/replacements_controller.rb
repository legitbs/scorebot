class ReplacementsController < ApplicationController
  def index
    @services = Service.enabled.all
    @teams = Team.all
  end

  def show
  end

  def new
    @services = Servuce.enabled.all
    @replacment = current_team.replacements.new
  end
end
