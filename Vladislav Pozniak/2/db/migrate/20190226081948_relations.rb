class Relations < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes_ingestions, id: false do |t|
      t.belongs_to :ingestion, index: true
      t.belongs_to :dish, index: true
    end
  end
end
