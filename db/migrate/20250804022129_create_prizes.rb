class CreatePrizes < ActiveRecord::Migration[7.1]
  def change
    create_table :prizes do |t|
      t.string :name, null: false
      t.integer :value_in_cents, null: false, default: 0
      t.float :probability, null: false, default: 0.0
      t.integer :stock, default: -1 # -1 para estoque infinito
      t.references :scratch_card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
