redis_config = case Rails.env
         when 'production'
           { host: 'bowmore',
             port: 6379,
             password: 'vueshosBevounWiedMontowmuzDoHondafDeyWor'
           }
         else
           {  }
         end

$redis = Redis.new redis_config
