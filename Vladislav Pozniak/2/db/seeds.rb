User.create!([
  {email: "1@us.er", password_digest: "$2a$10$T0OA7Pp1bliUKckfFDLEMu0NY8uTzWjP/gAdsfhtZ2JZkZHUQev8G", first_name: "User", last_name: "First", age: "18", weight: "77", height: "177"},
  {email: "2@us.er", password_digest: "$2a$10$T0OA7Pp1bliUKckfFDLEMu0NY8uTzWjP/gAdsfhtZ2JZkZHUQev8G", first_name: "User", last_name: "Second", age: "44", weight: "66", height: "188"}
])

Dish.create!([
  {name: "Bread", weight: 500, calorie_value: 100, proteins: 50, carbohydrates: 50, fats: 50, ingestion_id: nil},
  {name: "Banana", weight: 100, calorie_value: 300, proteins: 70, carbohydrates: 20, fats: 0, ingestion_id: nil},
  {name: "Milk", weight: 500, calorie_value: 200, proteins: 50, carbohydrates: 50, fats: 50, ingestion_id: nil}
])
