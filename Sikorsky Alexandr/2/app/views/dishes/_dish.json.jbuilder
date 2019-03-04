json.extract! dish, :id, :name, :weight, :calorie_value, :proteins, :carbohydrates, :fats, :created_at, :updated_at
json.url dish_url(dish, format: :json)
