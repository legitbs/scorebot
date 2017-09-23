source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'

gem 'pry-rails'
gem 'base62'
gem 'pngqr'

gem 'fog-aws'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'immigrant'

gem 'redis'

# Use SCSS for stylesheets
gem 'sass-rails'
gem 'haml-rails'
gem 'bourbon'
gem 'rdiscount'

gem 'listen'

gem 'cocaine'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier' #, '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails' #, '~> 4.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

gem 'high_voltage'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'

gem 'celluloid', require: false


gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof' # ruby 2.1+ only
gem 'memory_profiler'
gem 'statsd-instrument'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'rails-erd'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'therubyracer'
  gem 'puma'
end

group :development, :test do
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'mocha', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.0' # , bcrypt-ruby renamed to bcrypt

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
