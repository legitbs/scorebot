set :application, "scorebot"
set :repository,  "git@waitingf.org:scorebot.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "scorebot"                          # Your HTTP server, Apache/etc
role :app, "scorebot"                          # This may be the same as your `Web` server
role :db,  "scorebot", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :user, 'scorebot'
set :use_sudo, false
set :deploy_to, '/home/scorebot/app'

namespace :deploy do
  task :bundle, roles: :app do
    run "cd #{latest_release} && bundle install"
  end

  task :assets, roles: :app do
    run "cd #{latest_release} && RAILS_ENV=production rake assets:precompile"
  end
end

before "deploy:create_symlink", "deploy:bundle"
before "deploy:create_symlink", "deploy:assets"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
