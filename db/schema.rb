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

ActiveRecord::Schema.define(version: 2020_01_07_005550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "host_provider_accounts", force: :cascade do |t|
    t.string "name"
    t.string "username", null: false
    t.string "password", null: false
    t.boolean "online", default: true, null: false
    t.integer "used_space", default: 0, null: false
    t.jsonb "info"
    t.bigint "host_provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "host_providers_account_id"
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_provider_id"], name: "index_uploads_on_host_provider_id"
    t.index ["host_providers_account_id"], name: "index_uploads_on_host_providers_account_id"
    t.index ["online"], name: "index_uploads_on_online"
    t.index ["public"], name: "index_uploads_on_public"
    t.index ["video_id"], name: "index_uploads_on_video_id"
  end

  create_table "videos", force: :cascade do |t|
    t.jsonb "file_metadata"
    t.string "file_hash"
    t.string "name", null: false
    t.date "air_date"
    t.decimal "duration"
    t.boolean "processed", default: false, null: false
    t.string "download_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "primary_source_file_id", null: false
    t.integer "csv_number"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
