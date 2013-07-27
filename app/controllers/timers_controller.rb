class TimersController < ApplicationController
  def index
    @timers = Timer.feed
    render json: {timers: @timers, time: Time.now}
  end
end
