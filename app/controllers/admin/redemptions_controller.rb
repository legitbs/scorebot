class Admin::RedemptionsController < Admin::BaseController
  def index
    @redemptions = Redemption.order(created_at: :desc).limit(200)
  end

  def show
    @redemption = Redemption.find params[:id]
  end
end
