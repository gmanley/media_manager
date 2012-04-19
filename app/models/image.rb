class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :media
  mount_uploader :image, ImageUploader
end