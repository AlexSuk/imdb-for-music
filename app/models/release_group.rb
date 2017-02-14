class ReleaseGroup < ApplicationRecord
  has_many :releases
  has_many :tracks, :through => :releases
end
