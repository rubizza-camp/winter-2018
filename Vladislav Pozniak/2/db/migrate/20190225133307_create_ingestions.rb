class CreateIngestions < ActiveRecord::Migration[5.2]
  def change
    create_table :ingestions do |t|
      t.datetime :time
      t.belongs_to :user, foreign_key: true
      t.references :dish, index: true

      t.timestamps
    end
  end
end
