# app/controllers/api/v1/withdrawals_controller.rb
class Api::V1::WithdrawalsController < ApplicationController
  before_action :authenticate_user!

  def create
    withdrawal_params = params.require(:withdrawal).permit(:amount_in_cents, :pix_key_type, :pix_key)
    amount_to_withdraw = withdrawal_params[:amount_in_cents].to_i


    if current_user.balance_in_cents < amount_to_withdraw
      return render json: { error: "Saldo insuficiente." }, status: :unprocessable_entity
    end

    withdrawal = nil
    ActiveRecord::Base.transaction do
      current_user.decrement!(:balance_in_cents, amount_to_withdraw)

      withdrawal = current_user.withdrawals.create!(withdrawal_params)

      AuditLoggerService.new.call(
        user: current_user,
        action: 'withdrawal.requested',
        auditable_object: withdrawal,
        details: { amount: amount_to_withdraw }
      )
    end

    # --- LÓGICA MOCKADA ---
    # Aqui chamar o serviço que se comunica com o gateway de pagamento
    # para efetivamente enviar o Pix para o usuário.
    puts "====== MOCK WITHDRAWAL ======"
    puts "Withdrawal request #{withdrawal.id} created. The system would now process the Pix payout."
    puts "=============================="

    render json: WithdrawalSerializer.new(withdrawal).serializable_hash, status: :created

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def index
    user_withdrawals = current_user.withdrawals.order(created_at: :desc)
    pagy, withdrawals = pagy(user_withdrawals, items: 15)
    pagy_headers_merge(pagy)
    render json: WithdrawalSerializer.new(withdrawals).serializable_hash, status: :ok
  end
end
