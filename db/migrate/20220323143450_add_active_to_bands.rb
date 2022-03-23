class AddActiveToBands < ActiveRecord::Migration[6.1]
  def change
    add_column :bands, :active, :boolean, null: false, default: true
  end
end
