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

ActiveRecord::Schema.define(version: 2020_12_31_200721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audio_recs", force: :cascade do |t|
    t.string "title"
    t.integer "show_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_item_songs", force: :cascade do |t|
    t.integer "media_item_id"
    t.integer "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_items", force: :cascade do |t|
    t.string "public_id"
    t.integer "show_id"
    t.string "media_type"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "show_songs", force: :cascade do |t|
    t.integer "show_id"
    t.integer "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "set"
    t.integer "position"
  end

  create_table "shows", id: :serial, force: :cascade do |t|
    t.string "venue"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "lyrics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.integer "show_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
  end

end
