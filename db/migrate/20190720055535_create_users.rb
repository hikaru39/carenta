class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password, null: false
      t.string :name, null: false
      t.string :postal_code, null: false
      t.string :address1, null: false
      t.string :address2, null: false
      t.text :description
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.integer :administrator_flag, null: false
      t.timestamps
    end
  end
end
