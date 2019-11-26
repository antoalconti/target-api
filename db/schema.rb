# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_191_126_182_609) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'targets', force: :cascade do |t|
    t.bigint 'topic_id', null: false
    t.string 'title', null: false
    t.integer 'radius', null: false
    t.decimal 'latitude', null: false
    t.decimal 'longitude', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id', null: false
    t.index ['topic_id'], name: 'index_targets_on_topic_id'
    t.index ['user_id'], name: 'index_targets_on_user_id'
  end

  create_table 'topics', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_topics_on_name', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'full_name', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'provider', default: 'email', null: false
    t.string 'uid', default: '', null: false
    t.json 'tokens'
    t.integer 'gender', default: 0, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['uid', 'provider'], name: 'index_users_on_uid_and_provider', unique: true
  end

  add_foreign_key 'targets', 'topics'
  add_foreign_key 'targets', 'users'
end
