class HostProviderAccountPolicy < ApplicationPolicy
  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  private

  def admin?
    user.role_class >= Roles[:admin]
  end
end
