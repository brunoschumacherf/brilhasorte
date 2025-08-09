class Api::V1::Admin::GamesController < Api::V1::Admin::BaseController
  def index
    @q = Game.includes(:user, :prize, :scratch_card).ransack(params[:q])

    pagy, games = pagy(@q.result.order(created_at: :desc), items: 20)

    pagy_headers_merge(pagy)
    options = {
      include: [:user, :prize, :scratch_card]
    }
    render json: Admin::GameSerializer.new(games, options).serializable_hash, status: :ok
  end

  def show
    game = Game.includes(:user, :prize, :scratch_card).find(params[:id])
    render json: Admin::GameSerializer.new(game).serializable_hash, status: :ok
  end
end
