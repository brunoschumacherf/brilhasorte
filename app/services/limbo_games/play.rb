# app/services/limbo_games/play.rb
module LimboGames
  class Play
    def initialize(user:, params:)
      @user = user
      @bet_amount_in_cents = params[:bet_amount_in_cents].to_i
      @target_multiplier = BigDecimal(params[:target_multiplier].to_s)
      @config = LIMBO_GAME_CONFIG
    end

    def call
      validate_params!

      game = nil
      LimboGame.transaction do
        @user.lock!
        validate_balance!

        @user.update!(balance_in_cents: @user.balance_in_cents - @bet_amount_in_cents)

        result_multiplier = generate_result
        winnings = calculate_winnings(result_multiplier)

        if winnings > 0
          @user.update!(balance_in_cents: @user.balance_in_cents + winnings)
        end

        game = LimboGame.create!(
          user: @user,
          bet_amount_in_cents: @bet_amount_in_cents,
          target_multiplier: @target_multiplier,
          result_multiplier: result_multiplier,
          winnings_in_cents: winnings,
          status: winnings > 0 ? :won : :lost
        )
      end
      game
    end

    private

    def validate_params!
      raise 'Aposta inválida' if @bet_amount_in_cents <= 0
      raise 'Multiplicador alvo inválido' if @target_multiplier < 1.01
    end

    def validate_balance!
      raise 'Saldo insuficiente' if @user.balance_in_cents < @bet_amount_in_cents
    end

    def generate_result
      return 1.0 if rand * 100 < @config[:house_edge_percentage]

      roll = rand * 100
      cumulative_weight = 0

      @config[:probability_distribution].each do |range|
        cumulative_weight += range[:weight]
        if roll < cumulative_weight
          return rand(range[:from]..range[:to])
        end
      end

      last_range = @config[:probability_distribution].last
      rand(last_range[:from]..last_range[:to])
    end

    def calculate_winnings(result_multiplier)
      if result_multiplier >= @target_multiplier
        (@bet_amount_in_cents * @target_multiplier).to_i
      else
        0
      end
    end
  end
end
