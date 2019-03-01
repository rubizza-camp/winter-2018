# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :age
      t.string :weight
      t.string :height

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
