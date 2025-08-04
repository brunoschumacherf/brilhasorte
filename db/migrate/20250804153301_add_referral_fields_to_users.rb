class AddReferralFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :referral_code, :string
    add_reference :users, :referred_by, null: true, foreign_key: { to_table: :users }

    add_index :users, :referral_code, unique: true
  end
end
