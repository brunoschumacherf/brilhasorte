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
      begin
        efipay_response = EfipayWithdrawalService.new.send_pix(
          withdrawal_id: @withdrawal.id,
          amount_in_cents: @withdrawal.amount_in_cents,
          pix_key: @withdrawal.pix_key
        )

        @withdrawal.update!(
          status: 'processing',
        )

        render json: { message: 'Saque aprovado e Pix enviado com sucesso.' }, status: :ok
      rescue => e
        render json: { error: "Falha ao processar saque: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Este saque não pode ser aprovado.' }, status: :unprocessable_entity
    end
  end


  private

  def set_withdrawal
    @withdrawal = Withdrawal.find(params[:id])
  end
end
