class CreateDeposits < ActiveRecord::Migration[7.1]
  def change
    create_table :deposits do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_in_cents, null: false
      t.integer :status, default: 0, null: false
      t.string :gateway_transaction_id
      t.timestamps
    end
    add_index :deposits, :gateway_transaction_id, unique: true
  end
end
