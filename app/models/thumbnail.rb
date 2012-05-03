class Thumbnail
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :media, class_name: 'Media'
  mount_uploader :thumbnail, ImageUploader
end