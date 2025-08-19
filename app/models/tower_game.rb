# app/models/tower_game.rb
class TowerGame < ApplicationRecord
  belongs_to :user

  enum status: { active: 0, cashed_out: 1, lost: 2 }

  validates :difficulty, inclusion: { in: TOWER_GAME_CONFIG.keys.map(&:to_s) }
  validates :bet_amount_in_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :current_level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def config
    TOWER_GAME_CONFIG[difficulty.to_sym]
  end

  def next_multiplier
    config[:multipliers][current_level]
  end

  def next_potential_winnings
    (bet_amount_in_cents * next_multiplier).to_i
  end

  def current_winnings
    return 0 if current_level.zero?
    (bet_amount_in_cents * config[:multipliers][current_level - 1]).to_i
  end
end
