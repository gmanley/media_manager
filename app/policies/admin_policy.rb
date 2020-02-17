class AdminPolicy < ApplicationPolicy
  def dashboard?
    admin?
  end

  private

  def admin?
    user.role_class >= Roles[:admin]
  end
end
