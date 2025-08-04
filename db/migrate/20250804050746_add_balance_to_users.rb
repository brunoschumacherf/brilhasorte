class AddBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :balance_in_cents, :integer
  end
end
