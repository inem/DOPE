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

ActiveRecord::Schema[8.0].define(version: 2024_03_20_123004) do
  create_table "post_entries", force: :cascade do |t|
    t.string "timestamp_id", null: false
    t.integer "user_id", null: false
    t.integer "latest_post_id"
    t.index ["latest_post_id"], name: "index_post_entries_on_latest_post_id"
    t.index ["timestamp_id"], name: "index_post_entries_on_timestamp_id", unique: true
    t.index ["user_id"], name: "index_post_entries_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "parent_id"
    t.text "content", null: false
    t.string "uuid", null: false
    t.integer "version"
    t.float "similarity"
    t.boolean "latest", default: true
    t.string "content_hash"
    t.string "prefix_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_id", null: false
    t.index ["content_hash"], name: "index_posts_on_content_hash"
    t.index ["entry_id"], name: "index_posts_on_entry_id"
    t.index ["parent_id"], name: "index_posts_on_parent_id"
    t.index ["prefix_hash"], name: "index_posts_on_prefix_hash"
    t.index ["user_id"], name: "index_posts_on_user_id"
    t.index ["uuid"], name: "index_posts_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "auth_token"
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.integer "local_port"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "post_entries", "users"
  add_foreign_key "posts", "post_entries", column: "entry_id"
  add_foreign_key "posts", "posts", column: "parent_id"
  add_foreign_key "posts", "users"
end
