class Api::V1::Admin::PlinkoGamesController < Api::V1::Admin::BaseController
  def index
    @q = PlinkoGame.includes(:user).ransack(params[:q])
    pagy, games = pagy(@q.result.order(created_at: :desc), items: 20)

    pagy_headers_merge(pagy)

    options = {
      include: [:user]
    }

    render json: ::Admin::PlinkoGameSerializer.new(games, options).serializable_hash, status: :ok
  end
end
