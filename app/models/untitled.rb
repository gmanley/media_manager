
VideoScanner.new('/mnt/uploads/soshisubs', recursive: true).perform

SourceFile.all.each do |file|
  base_name = File.basename(file.path)
  like_files = SourceFile.where('path ilike ?', "%#{base_name}")

  like_files.each do |like_file|
    next if like_file.id == file.id

    old_video = like_file.video
    like_file.update(video_id: file.video_id)
    old_video&.destroy
  end
end

SourceFile.find(1886).video.update(name: '[SoShi Subs][2011.04.21] SSTV Tory Burch Anniversary Party Red Carpet - Yuri & Sooyoung.avi')
# id: 1886,
# path: "/mnt/uploads/soshisubs/samuelrocks/[SoShi Subs] SSTV Tory Burch Anniversary Party Red Carpet - Yuri & Sooyoung [04.21.2011].avi",

SourceFile.find(2002).video.update(name: '[SoShi Subs][2008.03.10] UFO Attack - SeoHyun & Jessica.avi')
# id: 2002,
# path: "/mnt/uploads/soshisubs/samuelrocks/[SoShi Subs] UFO Attack - Jessica Seohyun 03.11.08.avi",

SourceFile.find(2409).video.update(name: 'Chunji - Sunny & SooYoung [2008.11.07].avi')
# id: 2409,
# path: "/mnt/uploads/soshisubs/samuelrocks/[SoShi Subs] chunji 11.7.8.avi",

SourceFile.find(1466).video.update(name: '[SoShi Subs][2009.04.27] Making Goobne diary CF Long Version - SNSD.avi')
# id: 1466,
# path: "/mnt/uploads/soshisubs/samuelrocks/[SoShi Subs] Making Goobne diary CF Long Version - SNSD [ 04.27.09].avi",

SourceFile.find(1528).video.update(name: '[SoShi Subs][2008.06.12] Mnet Wide News Dr Wide SNSD Cut.avi')
# id: 1528,
# path: "/mnt/uploads/soshisubs/samuelrocks/[SoShi Subs] Mnet Wide News Dr Wide SNSD Cut [6.12.08].avi",

SourceFile.find(659).video.update(name: '[SoShi Subs][2009.11.27] Gubne New CF - Sooyoung.avi')
# id: 659,
# path: "/mnt/uploads/soshisubs/samuelrocks/[SoShi Subs] Gubne New CF - Sooyoung 11.27.09].avi",

SourceFile.find(695).video.update(name: '[SoShi Subs][2008.09.18] Hot Wide News SM Everysing - Taeyeon.avi')
# id: 695,
# path: "/mnt/uploads/soshisubs/samuelrocks/[SoShi Subs] Hot Wide News SM Everysing - Taeyeon [9.18.08].avi",

Video.where('name ilike ?', ' %').each do |video|
  video.name = video.name.strip
  video.save
end

Video.where('name ilike ?', '% ').each do |video|
  video.name = video.name.strip
  video.save
end

Video.where('name ilike ?', '%&amp;%').each do |video|
  video.name = video.name.gsub('&amp;', '&')
  video.save
end

Video.where('name like ?', '[Soshi Subs]%').each do |video|
  video.name = video.name.gsub('[Soshi Subs]', '[SoShi Subs]')
  video.save
end

Video.where('name ilike ?', '[SoShi_Subs]%').each do |video|
  video.name = video.name.gsub('[SoShi_Subs]', '[SoShi Subs]')
  video.save
end

Video.where('name ilike ?', '[SoshiSubs]%').each do |video|
  video.name = video.name.gsub('[SoshiSubs]', '[SoShi Subs]')
  video.save
end

old_date_format_videos = Video.where("name ~* ?", '\[\d{2}\.\d{2}\.\d{2}\]')
new_date_format_videos = Video.where("name ~* ?", '\[\d{4}\.\d{2}\.\d{2}\]')

ASSUMED_YEAR_CENTURY = '20'
OLD_DATE_FORMAT_REGEX = /\[(?<month>0[1-9]|1[012])\.(?<day>0[1-9]|\.[1-9]|[12][0-9]|3[01])\.(?<year>\d{2})\]/
old_date_format_videos.each do |video|
  if match = video.name.match(OLD_DATE_FORMAT_REGEX)
    year = match[:year]
    year.prepend(ASSUMED_YEAR_CENTURY)

    date_string = "#{year}.#{match[:month]}.#{match[:day]}"
    video.name = video.name.gsub(match.to_s, '').gsub('[Soshi Subs]', "[SoShi Subs][#{date_string}]").strip

    video.air_date = DateTime.strptime(
      "#{year}-#{match[:month]}-#{match[:day]}",
      '%Y-%m-%d'
    )
    video.save!
  end
end

NEW_DATE_FORMAT_REGEX = /\[(?<year>\d{4})\.(?<month>0[1-9]|1[012])\.(?<day>0[1-9]|\.[1-9]|[12][0-9]|3[01])\]/

new_date_format_videos.each do |video|
  if match = video.name.match(NEW_DATE_FORMAT_REGEX)
    video.air_date = DateTime.strptime(
      "#{match[:year]}-#{match[:month]}-#{match[:day]}",
      '%Y-%m-%d'
    )
    video.save!
  end
end

def handle_matched_videos(result:, matching_videos:, manual_intervention:, fully_manual:)
  if matching_videos.count == 1
    video = matching_videos.first
    if fully_manual
      binding.pry
    else
      video.csv_number = result[:number]
      video.save!
    end
  elsif matching_videos.count > 1
    puts "Multiple matches: #{matching_videos}"
    if matching_videos.count == 2
      video_1, video_2 = *matching_videos
      if video_1.file_hash == video_2.file_hash
        puts "Merging duplicate video #{video_2.id} into video #{video_1.id}"
        if manual_intervention
          binding.pry
        else
          video_2.source_files.update(video_id: video_1.id)
          video_2.destroy
          video_1.csv_number = result[:number]
          video_1.save!
        end
      else
        puts '2 matches'
        binding.pry if manual_intervention || fully_manual
      end
    else
      puts 'More than 2 matches'
      binding.pry if manual_intervention || fully_manual
    end
  end
end

require 'csv'
CSV_AIR_DATE_FORMAT = '%Y.%m.%d'
csv_path = '/mnt/uploads/soshisubs/goyangisica/Operation File Share_ - Sheet1.csv'
results = {}
deeper_search = true
deeper_deeper_seach = false
CSV.foreach(csv_path, headers: true, header_converters: [:downcase, :symbol]).each do |row|
  result = row.to_hash
  result[:number] = result.delete(:'')
  results[result[:number]] = result

  begin
    result[:parsed_date_aired] = Date.strptime(row[:date_aired], CSV_AIR_DATE_FORMAT)
  rescue => e
    puts "#{result['#']}: #{e} #{e.message}"
    next
  end

  result[:parsed_title] = result[:title].gsub(
    " [#{result[:parsed_date_aired].strftime(CSV_AIR_DATE_FORMAT)}]", ''
  )

  if video = Video.find_by(csv_number: result[:number])
    puts "#{result[:number]}: Already matched video_id: #{video.id}"
    next
  end

  matching_videos = Video.where(
    'name ilike ?', "%#{result[:parsed_title]}%"
  ).where(air_date: result[:parsed_date_aired])

  handle_matched_videos(result: result, matching_videos: matching_videos, manual_intervention: true, fully_manual: false)
  if matching_videos.count == 0
    if deeper_search
      matching_videos = Video.where(air_date: result[:parsed_date_aired])
      handle_matched_videos(
        result: result,
        matching_videos: matching_videos,
        manual_intervention: true,
        fully_manual: true
      )

      if matching_videos.count == 0
        if deeper_deeper_seach
          matching_videos = Video.where('name ilike ?', "%#{result[:parsed_title]}%")
          handle_matched_videos(
            result: result,
            matching_videos: matching_videos,
            manual_intervention: false,
            fully_manual: true
          )
        end
      end
    else
      puts "No matches for #{result[:number]}: #{result[:parsed_title]} - #{result[:parsed_date_aired]}"
    end
  end
end

Video.order(:updated_at).all.each do |video|
  if video.csv_number
    result = results[video.csv_number.to_s]
    # if !video.name.include?(result[:parsed_title])
      puts result[:title]
      puts video.name
      puts video.air_date
      puts video.id
      puts '----'
    # end
  end
end

not_well_formatted = Video.where.not("name ~* ?", '\[Soshi Subs\]\[\d{4}\.\d{2}\.\d{2}\]')


existing_accounts = HostProviderAccount.for_provider('mega').online.to_a
active_account = existing_accounts.pop
unuploaded_videos = Video.eager_load(:uploads).where(uploads: { id: nil })
unuploaded_videos.find_each do |video|
  if video.file_size > active_account.free_storage
    active_account = existing_accounts.pop

    unless active_account
      active_account = CreateRandomMegaAccount.new(base_email: 'ssfsoshisubs@gmail.com').perform
      until active_account.reload.online
        puts "waiting for #{active_account}"
        sleep 2
      end
    end
  end

  next if video.uploads.any?

  video.upload_to(:mega, account: active_account)
end
