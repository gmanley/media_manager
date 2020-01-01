require 'shellwords'

module HostProviders
  class Mega
    def initialize(video, remote_path: nil)
      @video = video
      @remote_path = remote_path
      @username = ENV['MEGA_USERNAME']
      @password = ENV['MEGA_PASSWORD']
    end

    def perform
      args = [
        'megaput',
        "-u #{@username}",
        "-p #{@password}"
      ]
      args << "--path #{@remote_path}" if remote_path
      args << @video.primary_source_file.path.shellescape

      system(args.join(' '))
    end
  end
end
