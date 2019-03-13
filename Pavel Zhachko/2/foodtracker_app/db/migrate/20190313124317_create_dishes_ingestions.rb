class CreateDishesIngestions < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes_ingestions do |t|
      t.references :dish, foreign_key: true
      t.references :ingestion, foreign_key: true

      t.timestamps
    end
  end
end
