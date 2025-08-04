class Api::V1::GamesController < ApplicationController
  before_action :authenticate_user!

    def index
    user_games = current_user.games.order(created_at: :desc)

    pagy, games = pagy(user_games, items: 10)

    pagy_headers_merge(pagy)
    options = { params: { reveal_secrets: true } }
    render json: GameSerializer.new(games, options).serializable_hash, status: :ok
  end

  def create
    scratch_card = ScratchCard.find(params[:scratch_card_id])
    result = GameCreationService.new(current_user, scratch_card).call

    if result.success?
      render json: GameSerializer.new(result.game).serializable_hash, status: :created
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end


  def reveal
    game = current_user.games.find_by!(id: params[:id], status: :pending)

    ActiveRecord::Base.transaction do
      game.update!(status: :finished, winnings_in_cents: game.prize.value_in_cents)
      current_user.increment!(:balance_in_cents, game.prize.value_in_cents)

      if game.winnings_in_cents > 0
        AuditLoggerService.new.call(
          user: current_user,
          action: 'game.prize_won',
          auditable_object: game,
          details: { winnings: game.winnings_in_cents }
        )
      end
    end

    options = { params: { reveal_secrets: true } }
    render json: GameSerializer.new(game, options).serializable_hash, status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Game not found or already finished." }, status: :not_found
  end
end
