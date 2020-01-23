class VerifyMegaAccount
  def initialize(mail:)
    @mail = mail
  end

  def perform
    doc = Nokogiri::HTML(@mail.html_part.body.to_s)
    verify_link = doc.at('//a[text()[contains(., "Verify my email")]]')
    if verify_link
      account_email = @mail.to.first
      account = HostProviderAccount.find_by(username: account_email)

      command = account.info['verify_command'].gsub('@LINK@', verify_link[:href])
      if system(command)
        account.update(online: true)
      end
    end
  end
end
