class ServiceState
  attr_accessor :redis, :state_name, :state_body

  def initialize(state_name, state_body={})
    self.redis = $redis
    self.state_name = state_name
    self.state_body = { entered_at: Time.now.to_f }.merge state_body
  end

  def channel_name
    "scorebot_service_state_#{Rails.env}"
  end

  def key_name
    "scorebot_service_current_state_#{Rails.env}"
  end

  def message_body
    {
      published_at: Time.now.to_f,
      state_name: state_name,
      state_body: state_body,
    }
  end

  def publish!
    redis.publish channel_name, message_body.to_json
    redis.set key_name, message_body.to_json
  end
end
