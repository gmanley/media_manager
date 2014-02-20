class VideoScanner

  def initialize(path, options = {})
    @path = path
    @options = options
  end

  def perform
    files = Find.find(path).find_all do |sub_path|
      VIDEO_EXTENSIONS.include?(File.extname(sub_path))
    end
    files = files.sample(@options[:limit]) if @options[:limit]

    files.each do |file_path|
      VideoProcessor.perform_async(file_path.mb_chars.compose.to_s)
    end
  end
end
