class For < ActiveRecord::Migration[5.2]
  def change
    add_column :ingestions, :time, :datetime
  end
end
