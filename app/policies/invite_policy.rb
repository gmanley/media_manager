class InvitePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def destroy?
    if admin?
      true
    elsif record.created_by_user_id == user.id
      true
    else
      false
    end
  end

  def permitted_attributes
    if admin?
      [:email, :role, :created_by_user_id]
    else
      [:email]
    end
  end

  private

  def admin?
    user.role_class >= Roles[:admin]
  end

  class Scope < Scope
    def resolve
      if user.role_class >= Roles[:contributor]
        scope.all
      else
        scope.where(public: true)
      end
    end
  end
end
