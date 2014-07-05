class RoundsController < ApplicationController
  helper_method :round

  def show
    respond_to do |fmt|
      fmt.png do
        send_data round.qr, type: 'image/png', disposition: 'inline'
      end
    end
  end

  private
  def round
    if params[:id] == 'latest'
      return @round ||= Round.where.not(signature: nil).first
    end
    @round ||= Round.find_by id: params[:id]
  end
end
