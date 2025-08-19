class Api::V1::Admin::TowerGamesController < Api::V1::Admin::BaseController
  def index
    @q = TowerGame.includes(:user).ransack(params[:q])
    pagy, games = pagy(@q.result.order(created_at: :desc))

    pagy_headers_merge(pagy)
    render json: Admin::TowerGameSerializer.new(games, include: [:user]).serializable_hash
  end
end
