class ScratchCard < ApplicationRecord
  has_many :prizes, dependent: :destroy
  accepts_nested_attributes_for :prizes, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :price_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }


  def draw_prize
    available_prizes = self.prizes.where("stock > 0 OR stock = -1")
    no_win_prize = self.prizes.find_by(value_in_cents: 0)

    return no_win_prize if available_prizes.empty? && no_win_prize

    weighted_prizes = available_prizes.flat_map { |p| [p] * (p.probability * 1000).to_i }
    weighted_prizes.sample
  end
end
