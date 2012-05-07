Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.remove Sidekiq::Middleware::Server::RetryJobs
    chain.remove Sidekiq::Middleware::Server::ActiveRecord
  end
end