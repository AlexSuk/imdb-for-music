class Release < ApplicationRecord
  has_many :tracks
  belongs_to :release_group
<<<<<<< HEAD
  belongs_to :artist
  validates :name, presence: true
  validates :mbid, presence: true
=======
>>>>>>> 560e374c6312f86c0d3234fc80f2880cbb688776
end
