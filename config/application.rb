require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MediaManager
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.load_defaults 6.0

    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('lib')

    config.active_record.schema_format = :sql

    config.generators do |g|
      g.test_framework      :rspec, fixture: true
      g.fixture_replacement :fabrication
    end
  end
end
