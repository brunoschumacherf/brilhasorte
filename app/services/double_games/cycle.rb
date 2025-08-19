# app/services/double_games/cycle.rb
module DoubleGames
  class Cycle
    def call
      round_to_finish = DoubleGameRound.betting.first
      return unless round_to_finish

      time_since_creation = Time.current - round_to_finish.created_at
      return if time_since_creation < DOUBLE_GAME_CONFIG[:betting_duration]

      round_to_finish.with_lock do
        return unless round_to_finish.betting?

        # --- FASE 1: SORTEIO ---
        winning_color = determine_winning_color
        round_to_finish.update!(status: :spinning, winning_color: winning_color)
        ActionCable.server.broadcast('double_game:main', { type: 'spinning', winning_color: winning_color })

        sleep DOUBLE_GAME_CONFIG[:spinning_duration]

        process_payouts(round_to_finish)
        round_to_finish.update!(status: :completed)

        completed_round_data = round_to_finish.reload.as_json(include: { bets: { include: :user } })
        ActionCable.server.broadcast('double_game:main', { type: 'completed', round: completed_round_data })

        sleep 3 # 3 segundos para exibir o resultado

        start_new_round
      end
    end

    private

    def determine_winning_color
      roll = rand * 100
      cumulative_prob = 0
      DOUBLE_GAME_CONFIG[:probabilities].each do |color, prob|
        cumulative_prob += prob
        return color.to_s if roll < cumulative_prob
      end
      DOUBLE_GAME_CONFIG[:probabilities].keys.last.to_s
    end

    def process_payouts(round)
      multiplier = DOUBLE_GAME_CONFIG[:multipliers][round.winning_color.to_sym]
      round.bets.find_each do |bet|
        bet.user.transaction do
          if bet.color == round.winning_color
            winnings = bet.bet_amount_in_cents * multiplier
            bet.update!(status: :won, winnings_in_cents: winnings)
            bet.user.update!(balance_in_cents: bet.user.balance_in_cents + winnings)
          else
            bet.update!(status: :lost)
          end
        end
      end
    end

    def start_new_round
      new_round = DoubleGameRound.create!(round_hash: SecureRandom.hex(16))
      round_data = new_round.as_json(include: { bets: { include: :user } })
      ActionCable.server.broadcast('double_game:main', { type: 'new_round', round: round_data })
    end
  end
end
