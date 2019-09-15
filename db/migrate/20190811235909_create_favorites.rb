class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :item, null: false
      t.references :user, null: false

      t.timestamps
    end
  end
end
