class PlinkoGame < ApplicationRecord
  belongs_to :user

  validates :bet_amount, :rows, :risk, :path, :multiplier, :winnings, presence: true
end
