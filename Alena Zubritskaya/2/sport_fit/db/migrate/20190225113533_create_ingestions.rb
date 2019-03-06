class CreateIngestions < ActiveRecord::Migration[5.2]
  def change
    create_table :ingestions do |t|
      t.references :user, foreign_key: true
      t.references :dish, foreign_key: true

      t.timestamps

    end
  end
end
