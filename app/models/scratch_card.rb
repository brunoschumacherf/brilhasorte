class ScratchCard < ApplicationRecord
  has_many :prizes, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
