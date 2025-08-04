class CreatePrizes < ActiveRecord::Migration[7.1]
  def change
    create_table :prizes do |t|
      t.string :name
      t.integer :value_in_cents
      t.float :probability
      t.integer :stock
      t.references :scratch_card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
