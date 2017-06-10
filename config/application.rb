require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scorebot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end


  def self.log(*args)
    timestamp = Time.now.to_s
    body = args.map{|a| a.is_a?(String) ? a : a.inspect }.join(' ')

    Rails.logger.info "#{timestamp} [scorebot] #{body}"
    $stderr.puts body
  end
end
