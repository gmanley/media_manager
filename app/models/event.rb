class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :segments

  field :name, type: String
  field :possible_names, type: Array
end