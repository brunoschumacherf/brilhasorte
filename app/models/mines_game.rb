class MinesGame < ApplicationRecord
  belongs_to :user

  validates :bet_amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :mines_count, presence: true, inclusion: { in: 1..24 }

  def next_multiplier
    Mines::Multiplier.for(
      mines_count: mines_count,
      revealed_count: revealed_tiles.count + 1
    )
  end

  def grid_reveal
    return nil if state == "active"
    self.grid
  end
end
