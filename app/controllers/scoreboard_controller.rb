class ScoreboardController < ApplicationController
  def index
  	@teams = Team.all
  end
end
