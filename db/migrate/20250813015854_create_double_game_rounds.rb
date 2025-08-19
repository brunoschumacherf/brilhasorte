class CreateDoubleGameRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :double_game_rounds do |t|
      t.integer :status, null: false, default: 0
      t.string :winning_color
      t.string :round_hash, null: false

      t.timestamps
    end
    add_index :double_game_rounds, :status
  end
end
