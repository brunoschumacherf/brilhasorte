class CreateWithdrawals < ActiveRecord::Migration[7.1]
  def change
    create_table :withdrawals do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount_in_cents, null: false
      t.integer :status, default: 0, null: false
      t.string :pix_key_type, null: false
      t.string :pix_key, null: false
      t.jsonb :gateway_response

      t.timestamps
    end
  end
end
