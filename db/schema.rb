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

ActiveRecord::Schema[7.1].define(version: 2025_08_13_015855) do
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
    t.bigint "bonus_code_id"
    t.integer "bonus_in_cents", default: 0
    t.index ["bonus_code_id"], name: "index_deposits_on_bonus_code_id"
    t.index ["gateway_transaction_id"], name: "index_deposits_on_gateway_transaction_id", unique: true
    t.index ["user_id"], name: "index_deposits_on_user_id"
  end

  create_table "double_game_bets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "double_game_round_id", null: false
    t.integer "bet_amount_in_cents", null: false
    t.integer "color", null: false
    t.integer "status", default: 0, null: false
    t.integer "winnings_in_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["double_game_round_id"], name: "index_double_game_bets_on_double_game_round_id"
    t.index ["user_id"], name: "index_double_game_bets_on_user_id"
  end

  create_table "double_game_rounds", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "winning_color"
    t.string "round_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_double_game_rounds_on_status"
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

  create_table "limbo_games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "bet_amount_in_cents", null: false
    t.decimal "target_multiplier", precision: 10, scale: 4, null: false
    t.decimal "result_multiplier", precision: 10, scale: 4
    t.integer "winnings_in_cents", default: 0
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_limbo_games_on_user_id"
  end

  create_table "mines_games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "bet_amount", null: false
    t.integer "mines_count", null: false
    t.jsonb "grid", null: false
    t.jsonb "revealed_tiles", default: []
    t.string "state", default: "active", null: false
    t.string "payout_multiplier", default: "1.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mines_games_on_user_id"
  end

  create_table "plinko_games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "bet_amount", null: false
    t.integer "rows", null: false
    t.string "risk", null: false
    t.jsonb "path", null: false
    t.string "multiplier", null: false
    t.integer "winnings", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_plinko_games_on_user_id"
  end

  create_table "prizes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "value_in_cents", default: 0, null: false
    t.float "probability", default: 0.0, null: false
    t.integer "stock", default: -1
    t.bigint "scratch_card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["scratch_card_id"], name: "index_prizes_on_scratch_card_id"
  end

  create_table "scratch_cards", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price_in_cents", default: 0, null: false
    t.text "description"
    t.string "image_url"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_scratch_cards_on_name", unique: true
  end

  create_table "ticket_replies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ticket_id", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_replies_on_ticket_id"
    t.index ["user_id"], name: "index_ticket_replies_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subject"
    t.integer "status", default: 0
    t.string "ticket_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_number"], name: "index_tickets_on_ticket_number", unique: true
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "tower_games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "difficulty", null: false
    t.integer "bet_amount_in_cents", null: false
    t.integer "status", default: 0, null: false
    t.integer "current_level", default: 0, null: false
    t.decimal "payout_multiplier", precision: 10, scale: 4, default: "1.0"
    t.integer "winnings_in_cents", default: 0
    t.jsonb "levels_layout", default: [], null: false
    t.jsonb "player_choices", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tower_games_on_user_id"
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
    t.bigint "balance_in_cents", default: 0, null: false
    t.string "full_name"
    t.string "cpf"
    t.date "birth_date"
    t.string "phone_number"
    t.string "referral_code"
    t.bigint "referred_by_id"
    t.datetime "last_free_game_claimed_at"
    t.boolean "admin", default: false, null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
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
  add_foreign_key "double_game_bets", "double_game_rounds"
  add_foreign_key "double_game_bets", "users"
  add_foreign_key "games", "prizes"
  add_foreign_key "games", "scratch_cards"
  add_foreign_key "games", "users"
  add_foreign_key "limbo_games", "users"
  add_foreign_key "mines_games", "users"
  add_foreign_key "plinko_games", "users"
  add_foreign_key "prizes", "scratch_cards"
  add_foreign_key "ticket_replies", "tickets"
  add_foreign_key "ticket_replies", "users"
  add_foreign_key "tickets", "users"
  add_foreign_key "tower_games", "users"
  add_foreign_key "users", "users", column: "referred_by_id"
  add_foreign_key "withdrawals", "users"
end
