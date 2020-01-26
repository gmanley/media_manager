source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.2', '>= 6.0.2.1'

gem 'sass-rails', '>= 6'
gem 'bourbon', github: 'thoughtbot/bourbon'

gem 'jquery-rails' # Bundles jQuery and the UJS adapter for it
gem 'bootstrap', '~> 4.4.1'
gem 'turbolinks', '~> 5'
gem 'haml' # Adds HAML support along with custom generators
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.7'

gem 'image_processing', '~> 1.2'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'pg', '>= 0.18', '< 2.0'
gem 'kaminari'
gem 'sunspot_rails'

gem 'jquery-datatables'

gem 'rabl'
gem 'yajl-ruby'

gem 'responders' # Customize respond_with behavior
gem 'simple_form' # Better rails form helpers
# gem 'multi_fetch_fragments' # Speeds up collection partial rendering

gem 'carrierwave' # File uploading
gem 'mini_magick' # Image processing (rmagick alternative)
gem 'fog' # Cloud service ruby client (used by carrierwave for S3 support)
gem 'rmagick', github: 'rmagick/rmagick'
# gem 'streamio-ffmpeg', github: 'streamio/streamio-ffmpeg'

gem 'nokogiri'
gem 'nori', '~> 1.1.0'

gem 'sidekiq'
gem 'sidekiq-failures' # Adds a way to monitor worker failures
gem 'sidekiq-batch'

gem 'unicode'
gem 'differ'

# Latest version 0.10 doesn't allow configuring content type
# Master version added support for doing so.
gem 'mail_room', git: 'https://github.com/tpitale/mail_room'
# Required by mail_room if using sidekiq delivery_method
gem 'charlock_holmes'

gem 'puma', '~> 4.1'

gem 'pry-rails' # Replaces regular rails console with a pry session

group :development do
  gem 'sunspot_solr'
  gem 'better_errors' # Amazing replacement of default rails error page
  gem 'binding_of_caller', platform: :ruby # Needed by better_errors for enhanced functionality

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara' # Acceptance test framework
  gem 'database_cleaner', github: 'bmabey/database_cleaner' # Database cleaning for better test isolation
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers' # Collection of helpful rspec macros
  gem 'simplecov', require: false # Code coverage tool
  gem 'fakefs', require: 'fakefs/safe'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails' # Test framework
  gem 'fabrication' # Fixtures replacement
  gem 'ffaker' # Test data generation
end
