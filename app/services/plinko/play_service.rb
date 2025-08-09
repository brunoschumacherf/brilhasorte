module Plinko
  class PlayService
    # Carrega os multiplicadores do arquivo YML
    MULTIPLIERS = YAML.load_file(Rails.root.join('config/plinko_multipliers.yml')).deep_symbolize_keys

    def initialize(user:, bet_amount:, rows:, risk:)
      @user = user
      @bet_amount = bet_amount.to_i
      @rows = rows.to_i
      @risk = risk.to_sym
      @errors = []
    end

    def call
      return ServiceResult.new(success: false, errors: ['Valores de aposta ou risco inválidos']) unless valid_params?
      return ServiceResult.new(success: false, errors: @errors) unless balance_sufficient?

      ActiveRecord::Base.transaction do
        debit_from_balance
        game_result = play_game
        credit_winnings(game_result[:winnings])
        @game = save_game(game_result)
      end

      ServiceResult.new(success: true, payload: @game)
    rescue ActiveRecord::RecordInvalid => e
      ServiceResult.new(success: false, errors: [e.message])
    end

    private

    attr_reader :user, :bet_amount, :rows, :risk

    def valid_params?
      bet_amount > 0 && [8, 9, 10, 11, 12, 13, 14, 15, 16].include?(rows) && [:low, :medium, :high].include?(risk)
    end

    def balance_sufficient?
      if user.balance_in_cents < bet_amount
        @errors << 'Saldo insuficiente'
        return false
      end
      true
    end

    def debit_from_balance
      user.update!(balance_in_cents: user.balance_in_cents - bet_amount)
    end

    def credit_winnings(winnings)
      user.update!(balance_in_cents: user.balance_in_cents + winnings)
    end

    def play_game
      path = Array.new(rows) { ['L', 'R'].sample }
      # A posição final é o número de vezes que a bola foi para a direita ('R')
      final_position_index = path.count('R')

      multiplier_set = MULTIPLIERS.dig(rows, risk)
      return { error: 'Multiplicadores não configurados para esta combinação' } unless multiplier_set

      multiplier = multiplier_set[final_position_index]
      winnings = (bet_amount * multiplier).to_i

      {
        path: path,
        multiplier: multiplier.to_s,
        winnings: winnings
      }
    end

    def save_game(result)
      PlinkoGame.create!(
        user: user,
        bet_amount: bet_amount,
        rows: rows,
        risk: risk.to_s,
        path: result[:path],
        multiplier: result[:multiplier],
        winnings: result[:winnings]
      )
    end
  end
end
