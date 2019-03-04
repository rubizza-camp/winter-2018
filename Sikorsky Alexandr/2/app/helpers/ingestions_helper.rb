module IngestionsHelper
  def total_calories(ingestion)
    return if ingestion.dishes.empty?

    calorie_values = ingestion.dishes.map(&:calorie_value).compact
    calorie_values.inject(&:+)
  end

  def dishes2str(ingestion)
    return if ingestion.dishes.empty?

    ingestion.dishes.map(&:name).join(', ')
  end
end
