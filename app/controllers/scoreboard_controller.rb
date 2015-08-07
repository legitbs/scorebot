class ScoreboardController < ApplicationController
  def index
    #    redirect_to dashboard_path unless is_legitbs?
    respond_to do |f|
      f.html do
        @teams = Team.for_scoreboard
      end
      f.json { render json: Team.as_standings_json }
    end
  end
end
