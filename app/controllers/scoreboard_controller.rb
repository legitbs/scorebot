class ScoreboardController < ApplicationController
  def index
    respond_to do |f|
      f.html do
        @teams = Team.for_scoreboard
        
        if Timer.game.remaining < 1.hour
          return redirect_to dashboard_path
        end
      end
      f.json { render json: Team.as_standings_json }
    end
  end
end
