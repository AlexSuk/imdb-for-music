class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :comments, as: :commentable
  validates :user_id, presence: true
  validates :body, presence: true # TODO: validate for a minimum length?
end
