class Segment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :media, class_name: 'Media'
end