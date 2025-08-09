class Api::V1::Admin::WithdrawalsController < Api::V1::Admin::BaseController
  before_action :set_withdrawal, only: [:show, :approve]

  def index
    @q = Withdrawal.includes(:user).ransack(params[:q])

    pagy, withdrawals = pagy(@q.result.order(created_at: :desc), items: 20)

    pagy_headers_merge(pagy)
    options = {
      include: [:user]
    }
    render json: Admin::WithdrawalSerializer.new(withdrawals, options).serializable_hash
  end

  def show
    withdrawal = Withdrawal.includes(:user).find(params[:id])
    render json: Admin::WithdrawalSerializer.new(withdrawal).serializable_hash
  end

  def approve
    if @withdrawal.pending?
      @withdrawal.update(status: 'completed')
      render json: { message: 'Saque aprovado com sucesso.' }, status: :ok
    else
      render json: { error: 'Este saque não pode ser aprovado.' }, status: :unprocessable_entity
    end
  end

  private

  def set_withdrawal
    @withdrawal = Withdrawal.find(params[:id])
  end
end
