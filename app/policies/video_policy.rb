class VideoPolicy < ApplicationPolicy
  def download?
    contributor?
  end

  def update?
    contributor?
  end

  def destroy?
    admin?
  end

  def index?
    true
  end

  def show?
    true
  end

  private

  def admin?
    user.role_class >= Roles[:admin]
  end

  def contributor?
    user.role_class >= Roles[:contributor]
  end
end
