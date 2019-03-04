class Ingestion < ApplicationRecord
  validate :date_cannot_be_in_the_future
  
  belongs_to :user
  has_and_belongs_to_many :dishes

  def date_cannot_be_in_the_future
    if time.present? && time > Date.today
      errors.add(:time, "can't be in the future")
    end
  end
end
