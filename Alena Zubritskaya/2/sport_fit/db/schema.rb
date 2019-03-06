# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_05_112113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dish_ingestions", force: :cascade do |t|
    t.bigint "dish_id"
    t.bigint "ingestion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dish_ingestions_on_dish_id"
    t.index ["ingestion_id"], name: "index_dish_ingestions_on_ingestion_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.integer "weight"
    t.integer "calorie_value"
    t.integer "proteins"
    t.integer "carbohydrates"
    t.integer "fats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingestions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "dish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_ingestions_on_dish_id"
    t.index ["user_id"], name: "index_ingestions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.integer "age"
    t.integer "weight"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "dish_ingestions", "dishes"
  add_foreign_key "dish_ingestions", "ingestions"
  add_foreign_key "ingestions", "dishes"
  add_foreign_key "ingestions", "users"
end
