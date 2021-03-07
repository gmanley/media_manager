Settings = Struct.new(:invite_only?, :minimum_role)
Rails.application.config.settings = Settings.new(
  ENV['APP_INVITE_ONLY'] == 'true',
  ENV['APP_MINIMUM_ROLE'] || 'guest'
)
