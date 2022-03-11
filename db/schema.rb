# frozen_string_literal: true

ActiveRecord::Schema.define(version: 20_220_311_211_004) do
  enable_extension 'plpgsql'

  create_table 'bands', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.string 'contact_name'
    t.string 'phone_number'
    t.text 'description'
    t.text 'social_links'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'username', null: false
    t.string 'password_digest'
    t.string 'email'
    t.string 'first_name'
    t.string 'last_name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
