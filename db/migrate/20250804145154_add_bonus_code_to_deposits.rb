class AddBonusCodeToDeposits < ActiveRecord::Migration[7.1]
  def change
    add_reference :deposits, :bonus_code, null: false, foreign_key: true
    add_column :deposits, :bonus_in_cents, :integer
  end
end
