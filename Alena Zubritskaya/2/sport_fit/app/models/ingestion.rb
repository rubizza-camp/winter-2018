class Ingestion < ApplicationRecord
  belongs_to :user, inverse_of: :ingestions
  has_many :dish_ingestions, dependent: :destroy
  has_many :dishes, through: :dish_ingestions
  validates :user_id, presence: true
  default_scope -> { order(created_at: :desc) }
end
