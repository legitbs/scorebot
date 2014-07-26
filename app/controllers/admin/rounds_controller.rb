class Admin::RoundsController < Admin::BaseController
  def index
    @rounds = Round.order(created_at: :desc)
  end
end
