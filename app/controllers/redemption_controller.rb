class RedemptionController < ApplicationController
  protect_from_forgery except: :create

  def create
    tokens = params[:tokens] || []
    redemptions = tokens.inject({}) do |m, t|
      r = begin 
            Redemption.redeem_for(current_team, t).uuid
          rescue => e
            "error: #{e.message}"
          end
      m[t] = r
      m
    end

    render json: redemptions.to_json
  end
end
