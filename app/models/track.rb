class Track < ApplicationRecord
  belongs_to :release
  validates :name, presence: true
  validates :release_id, presence: true
end
