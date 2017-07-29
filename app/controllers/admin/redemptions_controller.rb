class Admin::RedemptionsController < Admin::BaseController
  def index
    offset = params[:offset] || 0
    @redemptions = Redemption.order(created_at: :desc).limit(200).offset(offset)
  end

  def show
    @redemption = Redemption.find params[:id]
  end
end
