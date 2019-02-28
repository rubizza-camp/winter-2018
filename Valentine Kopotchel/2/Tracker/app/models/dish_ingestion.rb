class DishIngestion < ApplicationRecord
  belongs_to :dish
  belongs_to :ingestion
end
