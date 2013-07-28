class MessagesController < ApplicationController
  def index
    m = Message.get_for current_team, params[:since] || 0
    s = Time.now.to_i
    render json: {messages: m, since: s}
  end
end
