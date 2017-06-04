require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# module RestApp
module RestApp
  # class Application
  class Application < Rails::Application
    config.middleware.use 'CatchJsonParseErrors'
  end
end
