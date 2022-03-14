# frozen_string_literal: true

class RemoveEmailAndPasswordFromBands < ActiveRecord::Migration[6.1]
  def change
    remove_column :bands, :email, null: false
    remove_column :bands, :password_digest, null: false
  end
end
