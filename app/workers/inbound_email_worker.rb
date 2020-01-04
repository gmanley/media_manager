class InboundEmailWorker
  include Sidekiq::Worker

  MEGA_EMAIL = 'welcome@mega.nz'

  def perform(message)
    mail = Mail::Message.new(message)

    if mail.from.first == MEGA_EMAIL
      VerifyMegaAccount.new(email_body: mail.html_part.body.to_s).perform
    end
  end
end
