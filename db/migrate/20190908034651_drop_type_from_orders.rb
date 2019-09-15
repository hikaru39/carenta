class DropTypeFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :type, :integer, null: false
  end
end
