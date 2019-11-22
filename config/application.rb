require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

Bundler.require(:default, Rails.env)

module MediaManager
  class Application < Rails::Application
    config.generators do |g|
      g.orm                 :mongoid
      g.test_framework      :rspec, fixture: true
      g.fixture_replacement :fabrication
    end
  end
end
