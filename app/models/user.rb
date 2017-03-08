class User < ApplicationRecord
  before_save {self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # has_secure_password can:
  # 1.  save securely hashed password_digest attribute to database
  # 2.  creates virtual attributes :password and :password_confirmation
  #     for those attributes, validation for presence and match is
  #     included
  # 3.  create authenticate() method which returns a user when pw is correct
  # model requires password_digest attribute
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  has_many :reviews
end
