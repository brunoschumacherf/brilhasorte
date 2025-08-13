class CreateLimboGames < ActiveRecord::Migration[7.1]
  def change
    create_table :limbo_games do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :bet_amount_in_cents, null: false
      t.decimal :target_multiplier, precision: 10, scale: 4, null: false
      t.decimal :result_multiplier, precision: 10, scale: 4
      t.integer :winnings_in_cents, default: 0
      t.integer :status, null: false

      t.timestamps
    end
  end
end
