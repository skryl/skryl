# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120813220525) do

  create_table "activities", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "activity_id",   :null => false
    t.string   "activity_type", :null => false
    t.datetime "start_time",    :null => false
    t.string   "status",        :null => false
    t.boolean  "gps"
    t.integer  "latitude"
    t.integer  "longitude"
    t.boolean  "heartrate"
    t.string   "device_type",   :null => false
    t.float    "duration",      :null => false
    t.float    "distance",      :null => false
    t.integer  "calories",      :null => false
    t.text     "gps_data"
    t.text     "hr_data"
    t.text     "speed_data"
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.datetime "published_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "book_authors", :force => true do |t|
    t.integer  "book_id",    :limit => 255
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "books", :force => true do |t|
    t.integer  "goodreads_id", :null => false
    t.string   "isbn13"
    t.string   "title",        :null => false
    t.datetime "finished_at",  :null => false
    t.integer  "num_pages"
    t.integer  "rating"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "notes_url"
  end

  create_table "github_actions", :force => true do |t|
    t.string   "github_id"
    t.string   "title"
    t.string   "permalink"
    t.datetime "published_at"
    t.text     "content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "sleep_records", :force => true do |t|
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.datetime "bed_time",                                :null => false
    t.datetime "rise_time",                               :null => false
    t.date     "start_date",                              :null => false
    t.integer  "awakenings",                              :null => false
    t.integer  "awakenings_zq_points",                    :null => false
    t.integer  "time_in_deep",                            :null => false
    t.integer  "time_in_deep_percentage",                 :null => false
    t.integer  "time_in_deep_zq_points",                  :null => false
    t.integer  "time_in_light",                           :null => false
    t.integer  "time_in_light_percentage",                :null => false
    t.integer  "time_in_rem",                             :null => false
    t.integer  "time_in_rem_percentage",                  :null => false
    t.integer  "time_in_rem_zq_points",                   :null => false
    t.integer  "time_in_wake",                            :null => false
    t.integer  "time_in_wake_percentage",                 :null => false
    t.integer  "time_in_wake_zq_points",                  :null => false
    t.integer  "time_to_z",                               :null => false
    t.integer  "total_z",                                 :null => false
    t.integer  "total_z_zq_points",                       :null => false
    t.integer  "zq",                                      :null => false
    t.text     "sleep_graph",              :limit => 255, :null => false
    t.string   "sleep_graph_start_time",                  :null => false
  end

  create_table "tweets", :force => true do |t|
    t.string   "content"
    t.string   "permalink"
    t.string   "guid"
    t.datetime "published_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.boolean  "is_mention"
  end

end
