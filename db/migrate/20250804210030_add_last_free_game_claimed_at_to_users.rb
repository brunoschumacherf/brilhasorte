class AddLastFreeGameClaimedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_free_game_claimed_at, :datetime
  end
end
