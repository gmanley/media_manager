module Admin
  class PagesController < BaseController
    def dashboard
      authorize :admin, :dashboard?
    end
  end
end
