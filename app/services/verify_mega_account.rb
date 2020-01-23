class VerifyMegaAccount
  def initialize(email_body:)
    @email_body = email_body
  end

  def perform
    doc = Nokogiri::HTML(@email_body)
    verify_link = doc.at('//a[text()[contains(., "Verify my email")]]')
    if verify_link
      account_email = mail.to.first
      account = HostProviderAccount.find_by(username: account_email)

      command = account.info['verify_command'].gsub('@LINK@', verify_link[:href])
      if system(command)
        account.update(online: true)
      end
    end
  end
end
