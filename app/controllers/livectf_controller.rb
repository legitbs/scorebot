class LivectfController < ApplicationController
  def capture
    unless params[:flag].downcase ==
           'YouMayNotHaveROPedYetButYouWillNextTime'.downcase
      raise ActionController::RoutingError.new('Not Found')
    end

    payload = { submitted_at: Time.now.to_f,
                submitting_team: current_team
              }.to_json

    $redis.append 'livectf_submissions', payload

    render json: payload
  end
end
