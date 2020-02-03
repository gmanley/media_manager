module Sidekiq
  class ChewyMiddleware
    def initialize(strategy)
      @strategy = strategy
    end

    def call(*_)
      Chewy.strategy(@strategy) { yield }
    end
  end
end
