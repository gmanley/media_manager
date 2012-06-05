require File.expand_path('../../utils',  __FILE__)

namespace :media_manager do
  desc "Set the download urls of the media from a google drive account.
        Usage: 'rake \"media_manager:set_download_urls[email, password]\""
  task :set_download_urls, [:email, :password] => :environment do |t, args|
    if args.email.nil? || args.password.nil?
      puts "Please specify your google account email and password!
            Usage: 'rake \"media_manager:set_download_urls[email, password]\""
    else
      g_drive_url_retriever = Utils::GDriveURLRetriever.new(args.email, args.password)
      g_drive_url_retriever.start
    end
  end

  desc 'Normalize media record names'
  task :normalize_media_names => :environment do
    Media.all.each { |m| Utils.normalize_media_name(m) }
  end
end
