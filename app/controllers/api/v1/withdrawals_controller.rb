class Api::V1::WithdrawalsController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.cpf.blank?
      return render json: { error: "CPF não cadastrado. Por favor, cadastre seu CPF no perfil." }, status: :unprocessable_entity
    end

    params[:withdrawal][:pix_key] = current_user.cpf
    params[:withdrawal][:pix_key_type] = 'cpf'
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

      unless  withdrawal_params[:amount_in_cents] * 100 > 100
        efipay_response = EfipayWithdrawalService.new.send_pix(
          withdrawal_id: withdrawal.id,
          amount_in_cents: withdrawal.amount_in_cents,
          pix_key: withdrawal.pix_key
        )
        @withdrawal.update!(
          status: 'processing',
        )
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def cancel
    withdrawal = current_user.withdrawals.find_by(id: params[:id])

    if withdrawal.nil?
      return render json: { error: "Saque não encontrado ou não pertence a você." }, status: :not_found
    end

    unless ['pending'].include?(withdrawal.status)
      return render json: { error: "Este saque não pode ser cancelado, pois seu status é '#{withdrawal.status}'." }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      current_user.increment!(:balance_in_cents, withdrawal.amount_in_cents)

      withdrawal.update!(status: 'canceled')

      AuditLoggerService.new.call(
        user: current_user,
        action: 'withdrawal.canceled',
        auditable_object: withdrawal,
        details: { amount: withdrawal.amount_in_cents }
      )
    end

    render json: WithdrawalSerializer.new(withdrawal).serializable_hash, status: :ok

  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue => e
    render json: { error: "Falha ao cancelar saque: #{e.message}" }, status: :internal_server_error
  end


  def index
    user_withdrawals = current_user.withdrawals.order(created_at: :desc)
    pagy, withdrawals = pagy(user_withdrawals, items: 15)
    pagy_headers_merge(pagy)
    render json: WithdrawalSerializer.new(withdrawals).serializable_hash, status: :ok
  end
end
