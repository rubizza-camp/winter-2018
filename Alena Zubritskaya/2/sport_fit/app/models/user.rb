class User < ApplicationRecord
  has_many :ingestions, inverse_of: :user, dependent: :destroy
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  validates :surname,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  validates :age, presence: true, length: { maximum: 3 }
  validates :weight, presence: true, length: { maximum: 3 }
  validates :height, presence: true, length: { maximum: 3 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
