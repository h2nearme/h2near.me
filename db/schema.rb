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

ActiveRecord::Schema[7.0].define(version: 2023_03_24_120551) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "electricity_fees", force: :cascade do |t|
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offtaker_locations", force: :cascade do |t|
    t.bigint "offtaker_id", null: false
    t.string "name"
    t.float "longitude"
    t.float "latitude"
    t.string "postal_code"
    t.string "house_nr"
    t.boolean "own_transport"
    t.float "required_hydrogen_volume"
    t.float "required_oxygen_volume"
    t.float "required_hydrogen_pressure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "required_hydrogen_purity"
    t.string "prefixed_id"
    t.boolean "interest_oxygen", default: false
    t.integer "investment_period_years", default: 1
    t.integer "contract_period_years", default: 1
    t.index ["offtaker_id"], name: "index_offtaker_locations_on_offtaker_id"
  end

  create_table "offtakers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_offtakers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_offtakers_on_reset_password_token", unique: true
  end

  create_table "scenarios", force: :cascade do |t|
    t.bigint "offtaker_location_id", null: false
    t.bigint "supplier_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "costs_pipeline"
    t.integer "costs_road"
    t.integer "costs_import"
    t.float "distance"
    t.boolean "favourite", default: false
    t.json "value_breakdown"
    t.float "distance_straight_line"
    t.integer "costs_pipeline_straight_line"
    t.index ["offtaker_location_id"], name: "index_scenarios_on_offtaker_location_id"
    t.index ["supplier_location_id"], name: "index_scenarios_on_supplier_location_id"
  end

  create_table "supplier_locations", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.string "name"
    t.float "longitude"
    t.float "latitude"
    t.string "postal_code"
    t.string "house_nr"
    t.boolean "pickup_available"
    t.boolean "verified"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "purification_onsite"
    t.string "prefixed_id"
    t.float "has_drtfc"
    t.index ["supplier_id"], name: "index_supplier_locations_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_suppliers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_suppliers_on_reset_password_token", unique: true
  end

  create_table "supply_types", force: :cascade do |t|
    t.bigint "supplier_location_id", null: false
    t.string "name"
    t.float "minimum_hydrogen_volume"
    t.float "maximum_hydrogen_volume"
    t.float "pressure_type_hydrogen"
    t.integer "compression_costs"
    t.integer "transport_costs"
    t.index ["supplier_location_id"], name: "index_supply_types_on_supplier_location_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "offtaker_locations", "offtakers"
  add_foreign_key "scenarios", "offtaker_locations"
  add_foreign_key "scenarios", "supplier_locations"
  add_foreign_key "supplier_locations", "suppliers"
  add_foreign_key "supply_types", "supplier_locations"
end
