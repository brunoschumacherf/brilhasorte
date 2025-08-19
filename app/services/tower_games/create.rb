# app/services/tower_games/create.rb
module TowerGames
  class Create
    def initialize(user:, params:)
      @user = user
      @difficulty = params[:difficulty]
      @bet_amount_in_cents = params[:bet_amount_in_cents].to_i
      @config = TOWER_GAME_CONFIG[@difficulty.to_sym]
    end

    def call
      TowerGame.transaction do
        validate_balance!

        @user.lock!
        @user.update!(balance_in_cents: @user.balance_in_cents - @bet_amount_in_cents)

        create_tower_game!
      end
    end

    private

    def validate_balance!
      raise StandardError, 'Saldo insuficiente.' if @user.balance_in_cents < @bet_amount_in_cents
    end

    def generate_levels_layout
      Array.new(@config[:total_levels]) do
        level_options = Array.new(@config[:options_per_level], 'diamond')
        bombs_to_place = @config[:bombs_per_level]

        bomb_indices = (0...@config[:options_per_level]).to_a.sample(bombs_to_place)
        bomb_indices.each { |i| level_options[i] = 'bomb' }

        level_options
      end
    end

    def create_tower_game!
      TowerGame.create!(
        user: @user,
        difficulty: @difficulty,
        bet_amount_in_cents: @bet_amount_in_cents,
        levels_layout: generate_levels_layout
      )
    end
  end
end
