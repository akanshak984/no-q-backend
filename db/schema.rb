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

ActiveRecord::Schema.define(version: 2020_05_24_182141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "add_user_to_bookings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "store_id"
    t.string "mode"
    t.string "token"
    t.bigint "phone_number"
    t.datetime "booking_date"
    t.integer "slot_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.text "description"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "categories_stores", id: false, force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id", "store_id"], name: "index_categories_stores_on_category_id_and_store_id"
  end

  create_table "slots", force: :cascade do |t|
    t.bigint "store_id"
    t.integer "sequence"
    t.time "from_time"
    t.time "to_time"
    t.boolean "is_active", default: true
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["store_id"], name: "index_slots_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "code"
    t.integer "pincode"
    t.time "opening_time"
    t.time "closing_time"
    t.integer "duration"
    t.integer "capacity"
    t.bit "available_days", limit: 7
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_stores_on_code", unique: true
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.integer "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "whats_app_logs", force: :cascade do |t|
    t.string "sequence"
    t.string "status"
    t.string "error_message"
    t.bigint "phone_number"
    t.string "message_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "user_input"
  end

end
