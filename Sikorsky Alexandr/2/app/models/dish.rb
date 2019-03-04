class Dish < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :calorie_value, presence: true, numericality: true

  has_many :ingestions
  has_and_belongs_to_many :ingestions
  # has_many :users, through: :ingestions
end
