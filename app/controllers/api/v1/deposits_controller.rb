class Api::V1::DepositsController < ApplicationController
  def create
    deposit_params = params.require(:deposit).permit(:amount_in_cents)

    # Na implementação real, aqui a API do gateway,
    # pegaria o ID de transação deles e salvaria no `gateway_transaction_id`.
    # Por enquanto, geramos um ID falso.
    gateway_id = "dep_#{SecureRandom.hex(10)}"

    deposit = current_user.deposits.new(
      amount_in_cents: deposit_params[:amount_in_cents],
      status: :pending,
      gateway_transaction_id: gateway_id
    )

    if deposit.save
      render json: DepositSerializer.new(deposit).serializable_hash, status: :created
    else
      render json: { errors: deposit.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    deposit = current_user.deposits.find(params[:id])
    render json: DepositSerializer.new(deposit).serializable_hash, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Deposit not found." }, status: :not_found
  end
end
