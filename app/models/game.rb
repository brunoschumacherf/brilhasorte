# app/models/game.rb
class Game < ApplicationRecord
  belongs_to :user
  belongs_to :scratch_card
  belongs_to :prize, optional: true

  enum status: { pending: 0, finished: 1 }

  validates :game_hash, presence: true, uniqueness: true

  # TO DO: Gambeta
  def scratch_card_prize
    scratch_card.prizes
  end
end
