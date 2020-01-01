require 'shellwords'

module HostProviders
  class Mega
    Response = Struct.new(:path, :url, :success) do
      def success?
        success
      end
    end

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
      ext_name = File.extname(@video.primary_source_file.path)
      path = File.join(['/Root', @remote_path, @video.name].compact) << ext_name
      args << "--path #{path.shellescape}"
      args << @video.primary_source_file.path.shellescape

      if system(args.join(' '))
        args = [
          'megals',
          "-u #{@username}",
          "-p #{@password}",
          '-e',
          path.shellescape
        ]

        url = %x[#{args.join(' ')}].strip.split(' ').first
        @response = Response.new(path, url, true)
      else
        @response = Response.new(nil, nil, false)
      end
    end
  end
end
