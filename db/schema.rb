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

ActiveRecord::Schema.define(version: 20171129134406) do

  create_table "currencies", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_books", force: :cascade do |t|
    t.integer "pair_id"
    t.integer "depth"
    t.string "bid_hash"
    t.string "ask_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pair_id"], name: "index_order_books_on_pair_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.integer "first_currency_id"
    t.integer "second_currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_currency_id"], name: "index_pairs_on_first_currency_id"
    t.index ["second_currency_id"], name: "index_pairs_on_second_currency_id"
  end

  create_table "trios", force: :cascade do |t|
    t.integer "first_currency_id"
    t.integer "second_currency_id"
    t.integer "third_currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_currency_id"], name: "index_trios_on_first_currency_id"
    t.index ["second_currency_id"], name: "index_trios_on_second_currency_id"
    t.index ["third_currency_id"], name: "index_trios_on_third_currency_id"
  end

end
