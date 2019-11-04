class ChangeAdministratorFlagDefaultOnUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :administrator_flag, :integer, null: false, :default => 0
  end
end
