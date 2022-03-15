class CreateBandsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :bands_users, id: false do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :band, null: false, foreign_key: true

      t.index(%i[user_id band_id])
      t.timestamps
    end
  end
end
