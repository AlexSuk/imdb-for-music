class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}


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
