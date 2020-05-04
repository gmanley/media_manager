class UserPolicy < ApplicationPolicy
  def create?
    invite = Invite.find_by(id: record.invite_id)
    return false unless invite
    invite.redeemed_at.nil?
  end

  def update?
    admin? || record.id == user.id
  end

  def destroy?
    admin? || record.id == user.id
  end

  def show?
    true
  end

  # TODO: Don't allow people to set role
  def permitted_attributes
    [:email, :password, :role, :invite_id]
  end

  private

  def admin?
    user.role_class >= Roles[:admin]
  end

  def contributor?
    user.role_class >= Roles[:contributor]
  end
end
