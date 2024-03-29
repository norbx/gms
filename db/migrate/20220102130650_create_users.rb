# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest
      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
