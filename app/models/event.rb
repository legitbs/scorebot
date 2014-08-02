class Event
  attr_accessor :redis, :event_name, :event_body

  def initialize(event_name, event_body)
    self.redis = $redis
    self.event_name = event_name
    self.event_body = event_body
  end

  def channel_name
    "scorebot_#{Rails.env}"
  end

  def message_body
    {
      published_at: Time.now.to_f,
      event_name: event_name,
      event_body: event_body,
    }
  end

  def publish!
    redis.publish channel_name, message_body.to_json
  end
end
