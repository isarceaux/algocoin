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

ActiveRecord::Schema.define(version: 20180118133943) do

  create_table "arbitrages", force: :cascade do |t|
    t.integer "trio_id"
    t.integer "first_order_book_id"
    t.integer "second_order_book_id"
    t.integer "third_order_book_id"
    t.float "raw_ratio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "worst_ratio"
    t.index ["first_order_book_id"], name: "index_arbitrages_on_first_order_book_id"
    t.index ["second_order_book_id"], name: "index_arbitrages_on_second_order_book_id"
    t.index ["third_order_book_id"], name: "index_arbitrages_on_third_order_book_id"
    t.index ["trio_id"], name: "index_arbitrages_on_trio_id"
    t.index ["worst_ratio"], name: "index_arbitrages_on_worst_ratio"
  end

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

  create_table "trades", force: :cascade do |t|
    t.integer "poloniex_global_trade_id"
    t.integer "poloniex_trade_id"
    t.float "rate"
    t.float "amount"
    t.float "total"
    t.float "fee"
    t.integer "poloniex_order_number"
    t.string "type"
    t.string "category"
    t.integer "pair_id"
    t.time "trade_time"
    t.integer "arbitrage_id"
    t.boolean "passed_trade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arbitrage_id"], name: "index_trades_on_arbitrage_id"
    t.index ["pair_id"], name: "index_trades_on_pair_id"
    t.index ["trade_time"], name: "index_trades_on_trade_time"
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

  create_table "users", force: :cascade do |t|
    t.string "pseudo"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["pseudo"], name: "index_users_on_pseudo", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
