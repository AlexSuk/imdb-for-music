class Artist < ApplicationRecord
  validates :name, presence: true
  validates :mbid, presence: true, length: { is: 36 }, uniqueness: true
  has_many :release_groups
  has_many :releases, :through => :release_groups
end
