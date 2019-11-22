# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  include ActionView::Helpers::AssetTagHelper

  process :set_content_type

  version(:large)  { resize_to_fit(600, 600) }
  version(:medium) { resize_to_fit(400, 400) }
  version(:tiny)   { resize_to_fill(75, 75, 'North') }

  def store_dir
    File.join('uploads/images', model.id.to_s)
  end

  def default_url
    image_path('placeholder.png')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
