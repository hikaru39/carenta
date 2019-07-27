class AddPrefectureIdUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :prefecture_id, :integer, null: false
  end
end
