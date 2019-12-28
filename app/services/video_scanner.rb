require 'find'

class VideoScanner
  VIDEO_EXTENSIONS = %w[
    3gp asf asx avi flv m2t m2ts m2v m4v mkv
    mov mp4 mpeg mpg mts ts tp trp vob wmv swf
  ]

  def initialize(path, options = {})
    @path = path
    @options = options
  end

  def perform
    count = 0

    files.each do |path|
      break if count == @options[:limit]

      path = path.mb_chars.compose.to_s

      if video_file?(path)
        source_file = SourceFile.find_or_create_by!(path: path)
        video = source_file.video || Video.create(
          primary_source_file_id: source_file.id,
          source_files: [source_file]
        )
        VideoProcessingWorker.perform_async(video.id.to_s)

        count += 1
      end
    end
  end

  private

  def files
    if @options[:recursive]
      Find.find(@path)
    else
      Dir.entries(@path).map { |p| File.join(@path, p) }
    end
  end

  def video_file?(path)
    VIDEO_EXTENSIONS.include?(File.extname(path).delete('.'))
  end
end
