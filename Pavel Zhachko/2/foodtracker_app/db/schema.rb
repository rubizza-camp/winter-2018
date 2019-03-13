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

ActiveRecord::Schema.define(version: 2019_03_13_124317) do

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
    t.float "proteins"
    t.float "carbohydrates"
    t.float "fats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dishes_ingestions", force: :cascade do |t|
    t.bigint "dish_id"
    t.bigint "ingestion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dishes_ingestions_on_dish_id"
    t.index ["ingestion_id"], name: "index_dishes_ingestions_on_ingestion_id"
  end

  create_table "ingestions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "dish_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.datetime "time"
    t.index ["dish_id"], name: "index_ingestions_on_dish_id"
    t.index ["user_id"], name: "index_ingestions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.string "lastname"
    t.integer "age"
    t.integer "weight"
    t.integer "height"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dish_ingestions", "dishes"
  add_foreign_key "dish_ingestions", "ingestions"
  add_foreign_key "dishes_ingestions", "dishes"
  add_foreign_key "dishes_ingestions", "ingestions"
  add_foreign_key "ingestions", "dishes"
  add_foreign_key "ingestions", "users"
end
