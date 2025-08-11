module Api
  module V1
    class MinesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_active_game, only: [:reveal, :cashout, :active]

      def create
        service = Mines::CreateGameService.new(
          user: current_user,
          bet_amount: params[:bet_amount],
          mines_count: params[:mines_count]
        )
        result = service.call

        if result.success?
          render json: MinesGameSerializer.new(result.payload).serializable_hash, status: :ok
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def reveal
        service = Mines::RevealTileService.new(game: @game, row: params[:row], col: params[:col])
        result = service.call

        if result.success?
          render json: { status: result.payload[:status] , payload: MinesGameSerializer.new(result.payload[:game]).serializable_hash }, status: :ok
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def cashout
        multiplier = @game.payout_multiplier.to_f
        winnings = (@game.bet_amount * multiplier).to_i

        ActiveRecord::Base.transaction do
          @game.update!(state: 'cashed_out')
          current_user.update!(balance_in_cents: current_user.balance_in_cents + winnings)
        end
        render json: { status: 'cashed_out', winnings: winnings, payload: MinesGameSerializer.new(@game).serializable_hash }, status: :ok
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: "Falha no cash out: #{e.message}" }, status: :internal_server_error
      end

      def active
        if @game
          render json: @game, status: :ok
        else
          render json: { error: 'Nenhum jogo ativo' }, status: :not_found
        end
      end

      private

      def set_active_game
        @game = current_user.mines_games.find_by(state: 'active')
        render json: { error: 'Nenhum jogo ativo' }, status: :not_found unless @game
      end
    end
  end
end
