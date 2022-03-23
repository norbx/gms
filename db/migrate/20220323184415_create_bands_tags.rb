class CreateBandsTags < ActiveRecord::Migration[6.1]
  def change
    create_table :bands_tags, index: false do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :band, null: false, foreign_key: true
      t.index %i[tag_id band_id], unique: true

      t.timestamps
    end
  end
end
