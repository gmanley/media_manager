class VideoPolicy < ApplicationPolicy
  def download?
    user.meets_minimum_role? && contributor?
  end

  def update?
    user.meets_minimum_role? && contributor?
  end

  def destroy?
    user.meets_minimum_role? && admin?
  end

  def index?
    user.meets_minimum_role?
  end

  def show?
    user.meets_minimum_role?
  end

  private

  def admin?
    user.role_class >= Roles[:admin]
  end

  def contributor?
    user.role_class >= Roles[:contributor]
  end
end
