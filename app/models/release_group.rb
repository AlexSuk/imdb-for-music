class ReleaseGroup < ApplicationRecord
  has_many :releases
  has_many :tracks, :through => :releases
  belongs_to :artist
end
