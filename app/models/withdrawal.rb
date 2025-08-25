class Withdrawal < ApplicationRecord
  belongs_to :user

  enum status: { pending: 0, processing: 1, completed: 2, failed: 3, canceled: 4}

  validates :amount_in_cents, presence: true, numericality: { greater_than: 0 }
  validates :pix_key_type, presence: true
  validates :pix_key, presence: true
end
