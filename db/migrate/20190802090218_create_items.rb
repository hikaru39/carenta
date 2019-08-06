class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.integer :point
      t.integer :rental_point
      t.string :category, null: false
      t.string :condition, null: false
      t.text :description, null: false
      t.text :delivery_method, null: false
      t.integer :states, null: false
      
      t.timestamps null: false
    end
  end
end
