module TowerGames
  class CashOut
    def initialize(tower_game:)
      @game = tower_game
    end

    def call
      validate_game!

      TowerGame.transaction do
        @game.lock!
        @game.user.lock!

        winnings = @game.current_winnings
        @game.user.update!(balance_in_cents: @game.user.balance_in_cents + winnings)

        @game.update!(
          status: :cashed_out,
          winnings_in_cents: winnings
        )
      end

      @game
    end

    private

    def validate_game!
      raise StandardError, 'Este jogo não está mais ativo.' unless @game.active?
      raise StandardError, 'Você não pode retirar os ganhos antes do primeiro nível.' if @game.current_level.zero?
    end
  end
end
