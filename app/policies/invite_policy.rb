class InvitePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
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
      [:email, :role, :sender_id]
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
      if user.role_class >= Roles[:admin]
        scope.all
      else
        scope.where(sender_id: user.id)
      end
    end
  end
end
