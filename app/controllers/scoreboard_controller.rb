class ScoreboardController < ApplicationController
  def index
    respond_to do |f|
      f.html do
        @teams = Team.for_scoreboard        
      end
      f.json { render json: Team.as_standings_json }
    end
  end
end
