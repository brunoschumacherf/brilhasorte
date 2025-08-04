class Deposit < ApplicationRecord
  belongs_to :user

  belongs_to :bonus_code, optional: true


  enum status: { pending: 0, completed: 1, error: 2 }

  validates :amount_in_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
