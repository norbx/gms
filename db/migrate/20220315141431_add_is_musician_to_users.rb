class AddIsMusicianToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_musician, :boolean, null: false, default: false
  end
end
