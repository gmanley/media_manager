class SessionsController < Clearance::SessionsController
  skip_before_action :ensure_minimum_role, only: [:create, :new, :destroy]
end
