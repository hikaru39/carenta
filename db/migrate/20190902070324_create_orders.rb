class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :item, null: false
      t.references :user, null: false
      t.integer :type, null: false
      t.integer :status, null: false
      t.integer :rental_point
      t.integer :point
      
      t.timestamps
    end
  end
end
