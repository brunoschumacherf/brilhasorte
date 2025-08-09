class MinesGame < ApplicationRecord
  belongs_to :user

  validates :bet_amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :mines_count, presence: true, inclusion: { in: 1..24 }
end
