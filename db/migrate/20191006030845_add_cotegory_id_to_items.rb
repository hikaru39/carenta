class AddCotegoryIdToItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :category, :string, null: false
    
    add_column :items, :category_id, :integer
  end
end
