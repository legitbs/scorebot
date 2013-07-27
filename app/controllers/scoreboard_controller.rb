class ScoreboardController < ApplicationController
  def index
    @teams = Team.for_scoreboard
  end
end
