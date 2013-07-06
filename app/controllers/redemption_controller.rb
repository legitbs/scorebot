class RedemptionController < ApplicationController
  def create
    tokens = params[:tokens]
    redemptions = tokens.map{|t| Redemption.new t }
  end
end