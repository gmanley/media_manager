require 'shellwords'

module HostProviders
  class Mega
    Response = Struct.new(:path, :url, :success) do
      def success?
        success
      end
    end

    def initialize(username: nil, password: nil)
      @username = username
      @password = password
    end

    def check_usage?
      true
    end

    def create_account(username:, password:, name:)
      args = [
        'megareg',
        "-e #{username}",
        "-p #{password}",
        "-n #{name}",
        '--register',
        '--scripted'
      ]

      %x[#{args.join(' ')}]
    end

    def get_url(path)
      args = [
        'megals',
        "-u #{@username}",
        "-p #{@password}",
        '-e',
        path.shellescape
      ]

      %x[#{args.join(' ')}].strip.split(' ').first
    end

    def status
      args = [
        'megadf',
        "-u #{@username}",
        "-p #{@password}"
      ]
      response = %x[#{args.join(' ')}]
      match = response.match(/Total:\s+(?<total>\d+)\nUsed:\s+(?<used>\d+)\nFree:\s+(?<free>\d+)/)
      {
        total_space: match[:total],
        free_space: match[:free],
        used_space: match[:used]
      }
    end

    def upload(video, remote_path: nil)
      args = [
        'megaput',
        "-u #{@username}",
        "-p #{@password}"
      ]
      ext_name = File.extname(video.primary_source_file.path)
      path = File.join(['/Root', remote_path, video.name].compact) << ext_name
      args << "--path #{path.shellescape}"
      args << video.primary_source_file.path.shellescape

      if system(args.join(' '))
        url = get_url(path)
        @response = Response.new(path, url, true)
      else
        @response = Response.new(nil, nil, false)
      end
    end
  end
end
