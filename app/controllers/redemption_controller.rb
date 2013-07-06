class RedemptionController < ApplicationController
  def create
    tokens = params[:tokens]
    redemptions = tokens.map{|t| Redemption.redeem_for current_team, t }
  end
end