class Ingestion < ApplicationRecord
  belongs_to :user
  has_many :dish_ingestions, dependent: :destroy
  has_many :dishes, through: :dish_ingestions
end
