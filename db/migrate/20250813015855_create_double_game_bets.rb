class CreateDoubleGameBets < ActiveRecord::Migration[7.1]
  def change
    create_table :double_game_bets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :double_game_round, null: false, foreign_key: true
      t.integer :bet_amount_in_cents, null: false
      t.integer :color, null: false
      t.integer :status, null: false, default: 0
      t.integer :winnings_in_cents

      t.timestamps
    end
  end
end
