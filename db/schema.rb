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

ActiveRecord::Schema.define(version: 2021_08_12_041808) do

  create_table "billing_rate_by_days", force: :cascade do |t|
    t.string "billable_type"
    t.integer "billable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["billable_type", "billable_id"], name: "index_billing_rate_by_days_on_billable_type_and_billable_id"
  end

  create_table "billing_rate_weekdays", force: :cascade do |t|
    t.string "day"
    t.time "start_working_time"
    t.time "finish_working_time"
    t.decimal "inside_rate_per_hour", precision: 8, scale: 2, default: "0.0"
    t.decimal "outside_rate_per_hour", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "billing_rate_weekends", force: :cascade do |t|
    t.string "day"
    t.decimal "rate_per_hour", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "time_sheet_entries", force: :cascade do |t|
    t.date "date_of_entry", null: false
    t.time "start_time", null: false
    t.time "finish_time", null: false
    t.decimal "hour_billed", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date_of_entry"], name: "index_time_sheet_entries_on_date_of_entry"
  end

end
