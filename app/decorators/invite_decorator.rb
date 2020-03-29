class InviteDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def created_by_user
    helpers.link_to(object.created_by_user.email, object.created_by_user)
  end

  def redeemed_by_user
    helpers.link_to(object.created_by_user.email, object.created_by_user)
  end

  def redeemed_at
    helpers.content_tag :span, class: 'time' do
      object.redeemed_at.strftime("%a %d-%m-%Y")
    end
  end

  def invite_link
    helpers.invite_edit_path(object)
    # helpers.link_to(object.created_by_user.email, object.created_by_user)
  end
end
