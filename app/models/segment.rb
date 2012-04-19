class Segment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :video
end