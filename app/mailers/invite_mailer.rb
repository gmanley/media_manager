class InviteMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def invite_email
    @invite = params[:invite]
    @url = edit_invite_url(@invite)
    mail(to: @invite.email, subject: "You have been invited to #{ENV['WEBSITE_NAME']}")
  end
end
