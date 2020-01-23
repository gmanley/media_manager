require 'securerandom'

class CreateRandomMegaAccount
  def intialize(base_email:)
    @base_email = base_email
    @base_email_username, @base_email_domain = base_email.split('@')
  end

  def perform
    email = build_email(SecureRandom.hex(4))
    until HostProviderAccount.where(username: email).none?
      email = build_email(SecureRandom.hex(4))
    end

    password = SecureRandom.hex
    CreateMegaAccount.new(
      email: email,
      password: password,
      name: email.split('@').first
    )
  end

  private

  def build_email(new_email_component)
    "#{@base_email_username}+#{new_email_component}@#{@base_email_domain}"
  end
end
