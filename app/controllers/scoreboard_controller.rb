class ScoreboardController < ApplicationController
  def index
    @teams = Team.for_scoreboard
    
    if Timer.game.remaining < 1.hour
      return redirect_to dashboard_path
    end
    
    respond_to do |f|
      f.html
      f.json { render json: @teams.as_json }
    end
  end
end
