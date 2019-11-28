class Performance < Segment
  has_many :artists, as: :attributable
  belongs_to :event

  field :name, type: String
end