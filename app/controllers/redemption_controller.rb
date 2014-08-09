class RedemptionController < ApplicationController
  protect_from_forgery except: :create

  def create
    tokens = params[:tokens] || []
    successful = []
    redemptions = tokens.inject({}) do |m, t|
      next m if t.blank?
      r = begin 
            Stats.time "#{current_team.certname}.redeem_for" do
              rr = Redemption.redeem_for(current_team, t)
              successful << rr
              rr.uuid
            end
          rescue => e
            Scorebot.log "Redeem #{t} failed for #{current_team.try(:name)}: #{e.message}"
            "error: #{e.message}"
          end
      m[t] = r
      m
    end

    successful.each do |r|
      Event.new('redemption', r.as_event_json ).publish! rescue nil
    end

    render json: redemptions.to_json
  end
end
