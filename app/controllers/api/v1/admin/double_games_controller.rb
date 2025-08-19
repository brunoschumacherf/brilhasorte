class Api::V1::Admin::DoubleGamesController < Api::V1::Admin::BaseController
  def index
    @q = DoubleGameRound.includes(bets: :user).ransack(params[:q])
    pagy, rounds = pagy(@q.result.order(created_at: :desc))

    pagy_headers_merge(pagy)
    options = { include: [:bets, :'bets.user'] }
    render json: Admin::DoubleGameRoundSerializer.new(rounds, options).serializable_hash
  end
end
