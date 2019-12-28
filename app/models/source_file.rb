class SourceFile < ApplicationRecord
  belongs_to :video, required: false
end
