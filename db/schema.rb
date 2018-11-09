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

ActiveRecord::Schema.define(version: 2014_07_01_024426) do

  create_table "activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "activity_id", null: false
    t.string "activity_type", limit: 255, null: false
    t.datetime "start_time", null: false
    t.string "status", limit: 255
    t.boolean "gps"
    t.integer "latitude"
    t.integer "longitude"
    t.boolean "heartrate"
    t.string "device_type", limit: 255
    t.float "duration", null: false
    t.float "distance", null: false
    t.integer "calories", null: false
    t.text "gps_data"
    t.text "hr_data"
    t.text "speed_data"
  end

  create_table "book_authors", force: :cascade do |t|
    t.integer "book_id", limit: 255
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.integer "goodreads_id", null: false
    t.string "isbn13", limit: 255
    t.string "title", limit: 255, null: false
    t.datetime "finished_at", null: false
    t.integer "num_pages"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notes_url", limit: 255
  end

  create_table "github_actions", force: :cascade do |t|
    t.string "github_id", limit: 255
    t.string "title", limit: 255
    t.string "permalink", limit: 255
    t.datetime "published_at"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "permalink", limit: 255
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tag", limit: 255
  end

  create_table "tweets", force: :cascade do |t|
    t.string "content", limit: 255
    t.string "permalink", limit: 255
    t.string "guid", limit: 255
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_mention"
  end

end
