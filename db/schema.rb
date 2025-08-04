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

ActiveRecord::Schema[7.1].define(version: 2025_08_04_210629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audit_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "auditable_type"
    t.bigint "auditable_id"
    t.string "action", null: false
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditable_type", "auditable_id"], name: "index_audit_logs_on_auditable"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "bonus_codes", force: :cascade do |t|
    t.string "code", null: false
    t.float "bonus_percentage", default: 0.0, null: false
    t.datetime "expires_at"
    t.integer "max_uses", default: -1
    t.integer "uses_count", default: 0, null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_bonus_codes_on_code", unique: true
  end

  create_table "deposits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount_in_cents", null: false
    t.integer "status", default: 0, null: false
    t.string "gateway_transaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bonus_code_id", null: false
    t.integer "bonus_in_cents"
    t.index ["bonus_code_id"], name: "index_deposits_on_bonus_code_id"
    t.index ["gateway_transaction_id"], name: "index_deposits_on_gateway_transaction_id", unique: true
    t.index ["user_id"], name: "index_deposits_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "scratch_card_id", null: false
    t.bigint "prize_id"
    t.integer "status", default: 0, null: false
    t.integer "winnings_in_cents", default: 0
    t.string "server_seed"
    t.string "game_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_hash"], name: "index_games_on_game_hash", unique: true
    t.index ["prize_id"], name: "index_games_on_prize_id"
    t.index ["scratch_card_id"], name: "index_games_on_scratch_card_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "prizes", force: :cascade do |t|
    t.string "name"
    t.integer "value_in_cents"
    t.float "probability"
    t.integer "stock"
    t.bigint "scratch_card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["scratch_card_id"], name: "index_prizes_on_scratch_card_id"
  end

  create_table "scratch_cards", force: :cascade do |t|
    t.string "name"
    t.integer "price_in_cents"
    t.text "description"
    t.string "image_url"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.integer "balance_in_cents"
    t.string "full_name"
    t.string "cpf"
    t.date "birth_date"
    t.string "phone_number"
    t.string "referral_code"
    t.bigint "referred_by_id"
    t.datetime "last_free_game_claimed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["referral_code"], name: "index_users_on_referral_code", unique: true
    t.index ["referred_by_id"], name: "index_users_on_referred_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "withdrawals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount_in_cents", null: false
    t.integer "status", default: 0, null: false
    t.string "pix_key_type", null: false
    t.string "pix_key", null: false
    t.jsonb "gateway_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

  add_foreign_key "audit_logs", "users"
  add_foreign_key "deposits", "bonus_codes"
  add_foreign_key "deposits", "users"
  add_foreign_key "games", "prizes"
  add_foreign_key "games", "scratch_cards"
  add_foreign_key "games", "users"
  add_foreign_key "prizes", "scratch_cards"
  add_foreign_key "users", "users", column: "referred_by_id"
  add_foreign_key "withdrawals", "users"
end
