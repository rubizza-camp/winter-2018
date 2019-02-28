class Dish < ApplicationRecord
  has_many :dish_ingestions, dependent: :destroy
  has_many :ingestions, through: :dish_ingestions
  validates :name, :presence => true
  validates :weight, :presence => true
  validates :fats, :presence => true
  validates :proteins, :presence => true
  validates :carbohydrates, :presence => true
  validates :calorie_value, :presence => true
  def to_s
    self.name
  end
end
