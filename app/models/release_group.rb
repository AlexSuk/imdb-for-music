class ReleaseGroup < ApplicationRecord
  validates :name, presence: true
  validates :mbid, presence: true
  has_many :releases
  has_many :tracks, :through => :releases
  belongs_to :artist
end
