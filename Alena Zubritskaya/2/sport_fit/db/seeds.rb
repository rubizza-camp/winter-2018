# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  'Alena',
             surname: 'Fevrik',
             email: 'alenafevrik@gmail.com',
             age: '24',
             weight: '55',
             height: '169',
             password: 'alenafevrik',
             password_confirmation: 'alenafevrik',
             admin: true)
