# frozen_string_literal: true

class CreateBands < ActiveRecord::Migration[6.1]
  def change
    create_table :bands do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :contact_name
      t.string :phone_number
      t.text :description
      t.text :social_links

      t.timestamps
    end
  end
end
