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

ActiveRecord::Schema.define(version: 20_190_303_152_849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'dishes', force: :cascade do |t|
    t.string 'name'
    t.integer 'weight'
    t.integer 'calorie_value'
    t.integer 'proteins'
    t.integer 'carbohydrates'
    t.integer 'fats'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'dishes_ingestions', id: false, force: :cascade do |t|
    t.bigint 'dish_id', null: false
    t.bigint 'ingestion_id', null: false
    t.index %w[dish_id], name: 'index_dishes_ingestions_on_dish_id'
    t.index %w[ingestion_id], name: 'index_dishes_ingestions_on_ingestion_id'
  end

  create_table 'ingestions', force: :cascade do |t|
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'time'
    t.index %w[user_id], name: 'index_ingestions_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name', default: '', null: false
    t.string 'last_name', default: '', null: false
    t.string 'email', null: false
    t.string 'encrypted_password', default: '', null: false
    t.integer 'age', null: false
    t.integer 'weight', null: false
    t.integer 'height', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[email], name: 'index_users_on_email', unique: true
    t.index %w[reset_password_token], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'ingestions', 'users'
end
