class InboundEmailWorker
  include Sidekiq::Worker

  MEGA_EMAIL = 'welcome@mega.nz'

  def perform(message)
    mail = Mail::Message.new(message)

    if mail.from.first == MEGA_EMAIL
      VerifyMegaAccount.new(mail: mail).perform
    end
  end
end
