class LimboGame < ApplicationRecord
  belongs_to :user

  enum status: { won: 0, lost: 1 }

  validates :bet_amount_in_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :target_multiplier, numericality: { greater_than_or_equal_to: 1.01 }
  validates :status, presence: true

  scope :latest_for_user, ->(user) { where(user: user).order(created_at: :desc).limit(10) }
end
