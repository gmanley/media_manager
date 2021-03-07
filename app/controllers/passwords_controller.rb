class PasswordsController < Clearance::PasswordsController
  skip_before_action :ensure_minimum_role, only: [:create, :new]
end
