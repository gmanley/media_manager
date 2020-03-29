class InviteDecorator < Draper::Decorator
  delegate_all

  def created_by_user
    helpers.link_to(object.created_by_user.email, object.created_by_user)
  end

  def redeemed_by_user
    return unless object.redeemed_by_user
    helpers.link_to(object.redeemed_by_user.email, object.created_by_user)
  end

  def redeemed_at
    return unless object.redeemed_at
    helpers.content_tag :span, class: 'time' do
      object.redeemed_at.strftime("%a %d-%m-%Y")
    end
  end

  def invite_link
    helpers.edit_invite_url(object)
  end
end
