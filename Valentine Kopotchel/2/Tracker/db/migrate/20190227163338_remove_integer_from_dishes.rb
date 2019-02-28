class RemoveIntegerFromDishes < ActiveRecord::Migration[5.2]
  def change
    remove_column :dishes, :integer
  end
end
