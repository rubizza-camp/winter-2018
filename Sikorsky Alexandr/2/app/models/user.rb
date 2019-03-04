class User < ApplicationRecord
  has_many :ingestions
  has_many :dishes, through: :ingestions
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
