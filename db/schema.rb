# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_03_041456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "host_provider_accounts", force: :cascade do |t|
    t.string "name"
    t.string "username", null: false
    t.string "password", null: false
    t.boolean "online", default: true, null: false
    t.bigint "used_storage", default: 0, null: false
    t.jsonb "info"
    t.bigint "host_provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "total_storage"
    t.index ["host_provider_id"], name: "index_host_provider_accounts_on_host_provider_id"
  end

  create_table "host_providers", force: :cascade do |t|
    t.string "url", null: false
    t.string "name", null: false
    t.bigint "default_storage_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_host_providers_on_name"
  end

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

  create_table "source_files", force: :cascade do |t|
    t.string "path", null: false
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_source_files_on_path"
    t.index ["video_id"], name: "index_source_files_on_video_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "url", null: false
    t.string "remote_path"
    t.boolean "online", default: true, null: false
    t.boolean "public", default: true, null: false
    t.bigint "host_provider_id"
    t.bigint "host_provider_account_id"
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_provider_account_id"], name: "index_uploads_on_host_provider_account_id"
    t.index ["host_provider_id"], name: "index_uploads_on_host_provider_id"
    t.index ["online"], name: "index_uploads_on_online"
    t.index ["public"], name: "index_uploads_on_public"
    t.index ["video_id"], name: "index_uploads_on_video_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "videos", force: :cascade do |t|
    t.jsonb "file_metadata"
    t.string "file_hash"
    t.string "name", null: false
    t.date "air_date"
    t.decimal "duration"
    t.boolean "processed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "primary_source_file_id", null: false
    t.string "external_id"
  end

end
