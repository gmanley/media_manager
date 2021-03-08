class UserPolicy < ApplicationPolicy
  def new?
    if User.invite_only?
      if record.invite_id
        if Invite.find_by(id: record.invite_id)
          true
        else
          raise Pundit::NotAuthorizedError, reason: 'user.invalid_invite'
        end
      else
        raise Pundit::NotAuthorizedError, reason: 'user.no_invite'
      end
    end
  end

  def create?
    return true unless User.invite_only?

    if record.invite_id
      invite = Invite.find_by(id: record.invite_id)
      if invite
        if invite.redeemed_at.nil?
          true
        else
          raise Pundit::NotAuthorizedError, reason: 'user.already_redeemed_invite'
        end
      else
        raise Pundit::NotAuthorizedError, reason: 'user.invalid_invite'
      end
    elsif User.invite_only?
      raise Pundit::NotAuthorizedError, reason: 'user.no_invite'
    else
      true
    end
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
