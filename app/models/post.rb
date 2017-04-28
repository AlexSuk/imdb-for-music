class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable
  validates :user_id, presence: true
  validates :body, presence: true # TODO: validate for a minimum length?
  validates :mbid, presence: true
  validates :title, presence: true
end
