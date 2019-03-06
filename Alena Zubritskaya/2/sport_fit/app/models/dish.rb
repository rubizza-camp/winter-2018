class Dish < ApplicationRecord
  has_many :dish_ingestions, dependent: :destroy
  has_many :ingestions, through: :dish_ingestions
  validates :name,  presence: true, length: { maximum: 100 }
  before_save { name.downcase! }
  validates :weight, presence: true, length: { maximum: 10 }
  validates :calorie_value, presence: true, length: { maximum: 10 }
  validates :proteins, presence: true, length: { maximum: 10 }
  validates :carbohydrates, presence: true, length: { maximum: 10 }
  validates :fats, presence: true, length: { maximum: 10 }
end
