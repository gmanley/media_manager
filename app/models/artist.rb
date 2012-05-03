class Artist
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :members, class_name: self.name, inverse_of: :group, foreign_key: :group_id, autosave: true
  belongs_to :group, class_name: self.name, inverse_of: :members, index: true
  belongs_to :attributable, polymorphic: true

  field :name, type: String
end