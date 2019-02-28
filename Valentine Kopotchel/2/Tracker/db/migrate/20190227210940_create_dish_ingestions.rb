class CreateDishIngestions < ActiveRecord::Migration[5.2]
  def change
    create_table :dish_ingestions do |t|
      t.references :dish, foreign_key: true
      t.references :ingestion, foreign_key: true

      t.timestamps
    end
  end
end
