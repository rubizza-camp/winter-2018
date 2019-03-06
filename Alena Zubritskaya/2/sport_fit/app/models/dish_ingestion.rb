class DishIngestion < ApplicationRecord
  belongs_to :dish, optional: true
  belongs_to :ingestion
end
