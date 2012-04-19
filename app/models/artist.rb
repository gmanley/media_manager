class Artist
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :members, class_name: self.class.name, foreign_key: :group_id, inverse_of: :group
  belongs_to :group, class_name: self.class.name, inverse_of: :members, index: true
  belongs_to :attributable, polymorphic: true

  field :name, type: String
end