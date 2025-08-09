class CreateMinesGames < ActiveRecord::Migration[7.0]
  def change
    create_table :mines_games do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :bet_amount, null: false
      t.integer :mines_count, null: false
      t.jsonb :grid, null: false
      t.jsonb :revealed_tiles, default: []
      t.string :state, default: 'active', null: false
      t.string :payout_multiplier, default: "1.0", null: false
      t.timestamps
    end
  end
end
