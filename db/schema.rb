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

ActiveRecord::Schema[7.2].define(version: 2025_07_13_215631) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "guests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "rental_id", null: false
    t.string "card_owner"
    t.string "card_number", limit: 16
    t.string "card_cvc", limit: 3
    t.integer "card_exp_month"
    t.integer "card_exp_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rental_id"], name: "index_payments_on_rental_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer "bedrooms"
    t.integer "guest_capacity"
    t.string "city"
    t.float "width"
    t.float "length"
    t.float "surface"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "type"
    t.float "price"
    t.text "description"
    t.integer "living_property_type"
    t.boolean "enabled"
  end

  create_table "rentals", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer "owner_id", null: false
    t.integer "property_id", null: false
    t.integer "status", default: 0
    t.float "total_cost", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "accepted_at"
    t.text "cancel_reason"
    t.integer "cancelled_by_employee_id"
    t.index ["cancelled_by_employee_id"], name: "index_rentals_on_cancelled_by_employee_id"
    t.index ["owner_id"], name: "index_rentals_on_owner_id"
    t.index ["property_id"], name: "index_rentals_on_property_id"
  end

  create_table "rentals_users", force: :cascade do |t|
    t.integer "rental_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rental_id"], name: "index_rentals_users_on_rental_id"
    t.index ["user_id"], name: "index_rentals_users_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "message"
    t.integer "user_id", null: false
    t.integer "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_reviews_on_property_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest"
    t.string "dni"
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.integer "gender"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.boolean "enabled", default: true
    t.string "two_fa_token"
    t.datetime "two_fa_timestamp"
    t.index ["dni"], name: "index_users_on_dni", unique: true
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "payments", "rentals"
  add_foreign_key "rentals", "properties"
  add_foreign_key "rentals", "users", column: "cancelled_by_employee_id"
  add_foreign_key "rentals", "users", column: "owner_id"
  add_foreign_key "rentals_users", "rentals"
  add_foreign_key "rentals_users", "users"
  add_foreign_key "reviews", "properties"
  add_foreign_key "reviews", "users"
  add_foreign_key "sessions", "users"
end
