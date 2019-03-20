class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.integer :weight
      t.integer :calorie_value
      t.float :proteins
      t.float :carbohydrates
      t.float :fats

      t.timestamps
    end
  end
end
