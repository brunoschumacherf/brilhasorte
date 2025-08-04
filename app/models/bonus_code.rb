# app/models/bonus_code.rb
class BonusCode < ApplicationRecord
  before_save :uppercase_code

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :bonus_percentage, presence: true, numericality: { greater_than: 0 }
  validates :uses_count, numericality: { greater_than_or_equal_to: 0 }

  private

  def uppercase_code
    self.code.upcase!
  end
end
