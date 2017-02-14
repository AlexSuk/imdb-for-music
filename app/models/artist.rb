class Artist < ApplicationRecord
  has_many :release_groups
  has_many :releases, :through => :release_groups
end
