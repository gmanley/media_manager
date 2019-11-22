class VideoScanner
  VIDEO_EXTENSIONS = %w[
    3gp asf asx avi flv iso m2t m2ts m2v m4v mkv
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
        VideoProcessor.perform_async(path)
        count += 1
      end
    end
  end

  private

  def files
    if @options[:recursive]
      Find.find(path)
    else
      Dir.entries(path)
    end
  end

  def video_file?(path)
    VIDEO_EXTENSIONS.include?(File.extname(path.delete('.')))
  end
end
