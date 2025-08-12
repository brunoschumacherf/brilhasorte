# db/migrate/YYYYMMDDHHMMSS_create_tower_games.rb
class CreateTowerGames < ActiveRecord::Migration[7.1]
  def change
    create_table :tower_games do |t|
      t.references :user, null: false, foreign_key: true
      t.string :difficulty, null: false
      t.integer :bet_amount_in_cents, null: false
      t.integer :status, null: false, default: 0
      t.integer :current_level, null: false, default: 0
      t.decimal :payout_multiplier, precision: 10, scale: 4, default: 1.0
      t.integer :winnings_in_cents, default: 0
      t.jsonb :levels_layout, null: false, default: []
      t.jsonb :player_choices, null: false, default: []

      t.timestamps
    end
  end
end
