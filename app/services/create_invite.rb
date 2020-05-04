class CreateInvite
  def initialize(attributes)
    @attributes = attributes
  end

  def perform
    @invite = Invite.create(@attributes)
    InviteMailer.with(invite: @invite).invite_email
    @invite
  end
end
