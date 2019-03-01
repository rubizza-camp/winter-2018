class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.integer :weight
      t.integer :calorie_value
      t.integer :proteins
      t.integer :carbohydrates
      t.integer :fats
      t.references :ingestion, index: true

      t.timestamps
    end
    add_index :dishes, :name, unique: true
  end
end
