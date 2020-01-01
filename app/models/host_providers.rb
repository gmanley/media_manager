module HostProviders
  ALL = [
    Mega
  ]

  def self.[](provider)
    provider.to_sym
  end
end
