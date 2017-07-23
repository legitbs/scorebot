redis_config = case Rails.env
         when 'production'
           { host: 'redis' }
         else
           {  }
         end

$redis = Redis.new redis_config
