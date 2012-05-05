Nori.configure do |config|
  config.convert_tags_to { |tag| tag.snakecase.gsub(/_+/, '_').gsub(/@|_$/, '').to_sym }
  config.parser = :nokogiri
end