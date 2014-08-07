class Admin::RoundsController < Admin::BaseController
  def index
    @rounds = Round.order(created_at: :desc)
  end

  def show
    @round = Round.find params[:id]
  end
end
