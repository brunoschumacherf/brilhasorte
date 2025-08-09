class CreatePlinkoGames < ActiveRecord::Migration[7.0]
  def change
    create_table :plinko_games do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :bet_amount, null: false
      t.integer :rows, null: false
      t.string :risk, null: false
      t.jsonb :path, null: false
      t.string :multiplier, null: false
      t.integer :winnings, null: false

      t.timestamps
    end
  end
end
