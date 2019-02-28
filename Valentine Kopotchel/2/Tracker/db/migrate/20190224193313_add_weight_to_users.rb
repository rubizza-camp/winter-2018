class AddWeightToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :weight, :integer
  end
end
