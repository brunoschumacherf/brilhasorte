class Api::V1::Admin::DepositsController < Api::V1::Admin::BaseController
  def index
    @q = Deposit.includes(:user).ransack(params[:q])

    pagy, deposits = pagy(@q.result.order(created_at: :desc), items: 20)

    pagy_headers_merge(pagy)
    options = {
      include: [:user, :bonus_code]
    }
    render json: Admin::DepositSerializer.new(deposits, options).serializable_hash
  end

  def show
    deposit = Deposit.includes(:user, :bonus_code).find(params[:id])
    render json: Admin::DepositSerializer.new(deposit).serializable_hash
  end
end
