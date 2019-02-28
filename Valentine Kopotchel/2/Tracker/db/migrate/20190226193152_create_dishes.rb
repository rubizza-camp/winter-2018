class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.integer :weight
      t.string :calorie_value
      t.string :integer
      t.float :proteins
      t.float :carbohydrates
      t.float :fats

      t.timestamps
    end
  end
end
