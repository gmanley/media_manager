Settings = Struct.new(:invite_only?)
Rails.application.config.settings = Settings.new(
  ENV['APP_INVITE_ONLY'] == 'true'
)
