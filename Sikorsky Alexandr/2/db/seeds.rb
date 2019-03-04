# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  email: 'user@email.com', password: 'test123',
  first_name: 'Jon', last_name: 'Doe', age: '28', weight: '74', height: '181'
)

Dish.create([
              { name: 'Steak', weight: 100, calorie_value: 200, proteins: 20,
                carbohydrates: 1, fats: 10 },
              { name: 'Soup', weight: 300, calorie_value: 250, proteins: 4,
                carbohydrates: 6, fats: 4 },
              { name: 'potato', weight: 200, calorie_value: 400, proteins: 3,
                carbohydrates: 50, fats: 8 }
            ])
