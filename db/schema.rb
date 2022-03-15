# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_315_104_126) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'bands', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'contact_name'
    t.string 'phone_number'
    t.text 'description'
    t.text 'social_links'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'bands_users', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'band_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['band_id'], name: 'index_bands_users_on_band_id'
    t.index %w[user_id band_id], name: 'index_bands_users_on_user_id_and_band_id'
    t.index ['user_id'], name: 'index_bands_users_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'password_digest'
    t.string 'email'
    t.string 'first_name'
    t.string 'last_name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'bands_users', 'bands'
  add_foreign_key 'bands_users', 'users'
end
