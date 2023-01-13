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

ActiveRecord::Schema[7.0].define(version: 2023_01_13_142723) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "offtaker_locations", force: :cascade do |t|
    t.bigint "offtaker_id", null: false
    t.string "name"
    t.string "longitude"
    t.string "latitude"
    t.string "postal_code"
    t.string "house_nr"
    t.boolean "own_transport"
    t.float "req_hydrogen_vol"
    t.float "req_oxygen_vol"
    t.float "req_pressure_hydrogen"
    t.float "req_pressure_oxygen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "costs_pipeline"
    t.integer "costs_road"
    t.integer "costs_import"
    t.float "distance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offtaker_location_id"], name: "index_scenarios_on_offtaker_location_id"
    t.index ["supplier_location_id"], name: "index_scenarios_on_supplier_location_id"
  end

  create_table "supplier_locations", force: :cascade do |t|
    t.bigint "supplier_id", null: false
    t.string "name"
    t.string "longitude"
    t.string "latitude"
    t.string "postal_code"
    t.string "house_nr"
    t.string "supply_type"
    t.float "min_hydrogen_vol"
    t.float "max_hydrogen_vol"
    t.float "min_oxygen_vol"
    t.float "max_oxygen_vol"
    t.boolean "pickup_available"
    t.string "pressure_type_hydrogen"
    t.string "pressure_type_oxygen"
    t.string "energy_type"
    t.boolean "verified"
    t.boolean "available"
    t.integer "transport_costs"
    t.integer "compression_costs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "offtaker_locations", "offtakers"
  add_foreign_key "scenarios", "offtaker_locations"
  add_foreign_key "scenarios", "supplier_locations"
  add_foreign_key "supplier_locations", "suppliers"
end
