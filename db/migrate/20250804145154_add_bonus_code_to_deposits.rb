class AddBonusCodeToDeposits < ActiveRecord::Migration[7.1]
  def change
    add_reference :deposits, :bonus_code, null: true, foreign_key: true
    add_column :deposits, :bonus_in_cents, :integer, default: 0, null: false
  end
end
