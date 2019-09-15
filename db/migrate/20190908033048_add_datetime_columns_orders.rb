class AddDatetimeColumnsOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :ordered_at, :datetime
    add_column :orders, :delivered_at, :datetime
    add_column :orders, :received_at, :datetime
    add_column :orders, :returned_at, :datetime
    add_column :orders, :finished_at, :datetime
  end
end
