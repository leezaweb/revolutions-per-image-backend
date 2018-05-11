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

ActiveRecord::Schema.define(version: 20180508015017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "album_genres", force: :cascade do |t|
    t.bigint "album_id"
    t.bigint "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_album_genres_on_album_id"
    t.index ["genre_id"], name: "index_album_genres_on_genre_id"
  end

  create_table "albums", force: :cascade do |t|
    t.string "artist"
    t.string "title"
    t.string "image"
    t.integer "year"
    t.float "rating"
    t.integer "likes"
    t.bigint "visual_artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visual_artist_id"], name: "index_albums_on_visual_artist_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visual_artists", force: :cascade do |t|
    t.string "name"
    t.string "resource_url"
    t.string "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end