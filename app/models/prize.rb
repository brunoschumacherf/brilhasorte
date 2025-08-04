class Prize < ApplicationRecord
  belongs_to :scratch_card

  validates :name, :probability, presence: true
  validates :value_in_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :probability, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1.0 }
end
