class AlterItemsStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :states, :status
  end
end
