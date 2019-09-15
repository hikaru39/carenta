class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.references :user, null: false
      t.integer :point, null: false
      t.integer :difference, null: false
      t.string :category, null: false
      t.datetime :processed_at, null: false
      
      t.timestamps
    end
  end
end
