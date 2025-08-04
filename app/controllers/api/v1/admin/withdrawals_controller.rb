class Api::V1::Admin::WithdrawalsController < Api::V1::Admin::BaseController
  def index
    @q = Withdrawal.includes(:user).ransack(params[:q])

    pagy, withdrawals = pagy(@q.result.order(created_at: :desc), items: 20)

    pagy_headers_merge(pagy)
    render json: Admin::WithdrawalSerializer.new(withdrawals).serializable_hash
  end

  def show
    withdrawal = Withdrawal.includes(:user).find(params[:id])
    render json: Admin::WithdrawalSerializer.new(withdrawal).serializable_hash
  end
end
