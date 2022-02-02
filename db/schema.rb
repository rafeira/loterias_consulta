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

ActiveRecord::Schema.define(version: 2022_02_02_181219) do

  create_table "awards", force: :cascade do |t|
    t.string "nome"
    t.integer "raffle_id", null: false
    t.integer "winners_quantity"
    t.decimal "total_values"
    t.integer "hits"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["raffle_id"], name: "index_awards_on_raffle_id"
  end

  create_table "raffles", force: :cascade do |t|
    t.string "name"
    t.integer "contest_number"
    t.datetime "contest_date"
    t.bigint "contest_date_milliseconds"
    t.string "place_realization"
    t.string "apportionment_processing"
    t.string "accumulated"
    t.decimal "accumulated_value"
    t.string "dozens"
    t.decimal "total_collection"
    t.integer "next_contest"
    t.datetime "next_contest_date"
    t.bigint "next_contest_date_milliseconds"
    t.decimal "estimated_value_next_contest"
    t.decimal "valor_acumulado_especial"
    t.string "special_accumulated_value"
    t.boolean "special_contest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "winner_places", force: :cascade do |t|
    t.integer "raffle_id", null: false
    t.string "place"
    t.string "city"
    t.string "uf"
    t.integer "winners_quantity"
    t.boolean "electronic_channel"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["raffle_id"], name: "index_winner_places_on_raffle_id"
  end

  add_foreign_key "awards", "raffles"
  add_foreign_key "winner_places", "raffles"
end
