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

ActiveRecord::Schema.define(version: 2019_12_15_015342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "snapshot_indices", force: :cascade do |t|
    t.integer "grid_size", default: [3, 3], array: true
    t.string "image"
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id"], name: "index_snapshot_indices_on_video_id"
  end

  create_table "snapshots", force: :cascade do |t|
    t.decimal "video_time", null: false
    t.boolean "processed", default: false, null: false
    t.string "image"
    t.bigint "snapshot_index_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["snapshot_index_id"], name: "index_snapshots_on_snapshot_index_id"
  end

  create_table "videos", force: :cascade do |t|
    t.jsonb "file_metadata"
    t.string "file_path", null: false
    t.string "file_hash"
    t.string "name", null: false
    t.date "air_date"
    t.decimal "duration"
    t.boolean "processed", default: false, null: false
    t.string "download_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_path"], name: "index_videos_on_file_path"
  end

end
