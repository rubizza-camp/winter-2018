class AddNameToIngestions < ActiveRecord::Migration[5.2]
  def change
    add_column :ingestions, :name, :string
  end
end
