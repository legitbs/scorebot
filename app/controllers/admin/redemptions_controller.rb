class Admin::RedemptionsController < Admin::BaseController
  def index
    @redemptions = Redemption.order(created_at: :desc).limit(50)
  end
  def show
  end
end
