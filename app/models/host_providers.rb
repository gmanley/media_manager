module HostProviders
  ALL = [
    mega: Mega
  ]

  def self.[](provider)
    ALL[provider.to_sym]
  end
end
