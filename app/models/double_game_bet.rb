# app/models/double_game_bet.rb
class DoubleGameBet < ApplicationRecord
  belongs_to :user
  belongs_to :double_game_round, class_name: 'DoubleGameRound'

  enum color: { black: 0, red: 1, white: 2 }
  enum status: { pending: 0, won: 1, lost: 2 }

  validates :bet_amount_in_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :color, presence: true
end
