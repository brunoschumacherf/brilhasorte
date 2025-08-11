module Mines
  class CreateGameService
    def initialize(user:, bet_amount:, mines_count:)
      @user = user
      @bet_amount = bet_amount.to_i
      @mines_count = mines_count.to_i
      @errors = []
    end

    def call
      @user.mines_games.where(state: 'active').update_all(state: 'cashed_out')

      return ServiceResult.new(success: false, errors: ['A aposta deve ser maior que zero']) if @bet_amount <= 0
      return ServiceResult.new(success: false, errors: @errors) unless balance_sufficient?

      game = create_new_game

      if game.persisted?
        debit_from_balance
        ServiceResult.new(success: true, payload: game)
      else
        ServiceResult.new(success: false, errors: game.errors.full_messages)
      end
    end

    private

    attr_reader :user, :bet_amount, :mines_count

    def balance_sufficient?
      # CORREÇÃO AQUI
      if user.balance_in_cents < bet_amount
        @errors << 'Saldo insuficiente'
        return false
      end
      true
    end

    def create_new_game
      user.mines_games.create(
        bet_amount: bet_amount,
        mines_count: mines_count,
        grid: generate_grid,
        state: 'active',
        payout_multiplier: "1.0"
      )
    end

    def debit_from_balance
      user.update!(balance_in_cents: user.balance_in_cents - bet_amount)
    end

    def generate_grid
      grid = Array.new(5) { Array.new(5, 'diamond') }
      placed_mines = 0
      while placed_mines < mines_count
        row = rand(5)
        col = rand(5)
        if grid[row][col] == 'diamond'
          grid[row][col] = 'mine'
          placed_mines += 1
        end
      end
      grid
    end
  end
end
