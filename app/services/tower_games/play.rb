module TowerGames
  class Play
    def initialize(tower_game:, choice_index:)
      @game = tower_game
      @choice_index = choice_index.to_i
      @level_layout = @game.levels_layout[@game.current_level]
    end

    def call
      validate_game_status!

      chosen_item = @level_layout[@choice_index]

      @game.player_choices << @choice_index

      if chosen_item == 'bomb'
        handle_loss
      else
        handle_win
      end

      @game.save!
      @game
    end

    private

    def validate_game_status!
      raise StandardError, 'Este jogo não está mais ativo.' unless @game.active?
    end

    def handle_loss
      @game.status = :lost
    end

    def handle_win
      @game.current_level += 1
      if @game.current_level == @game.config[:total_levels]
        cash_out_winnings
      end
    end

    def cash_out_winnings
      winnings = @game.current_winnings
      @game.user.update!(balance_in_cents: @game.user.balance_in_cents + winnings)
      @game.winnings_in_cents = winnings
      @game.status = :cashed_out
    end
  end
end
