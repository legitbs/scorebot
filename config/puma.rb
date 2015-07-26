workers Integer(ENV['WEB_CONCURRENCY'] || 3)
thread_count = Integer(ENV['WEB_THREADS'] || 5)
threads thread_count, thread_count
port ENV['PORT'] || 3000
pidfile 'tmp/pids/puma.pid'
activate_control_app 'tcp://0.0.0.0:27420', auth_token: 'obWujyosh'

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
