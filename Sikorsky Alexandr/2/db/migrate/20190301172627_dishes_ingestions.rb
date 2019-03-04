class DishesIngestions < ActiveRecord::Migration[5.2]
  def change
    create_join_table :dishes, :ingestions do |t|
      t.index :dish_id
      t.index :ingestion_id
    end
  end
end
