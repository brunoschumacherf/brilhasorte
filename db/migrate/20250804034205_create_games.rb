# db/migrate/YYYYMMDDHHMMSS_create_games.rb
class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.references :scratch_card, null: false, foreign_key: true
      t.references :prize, null: true, foreign_key: true # Prêmio é revelado depois
      t.integer :status, default: 0, null: false # 0: pending, 1: finished
      t.integer :winnings_in_cents, default: 0
      t.string :server_seed
      t.string :game_hash

      t.timestamps
    end
    add_index :games, :game_hash, unique: true
  end
end
