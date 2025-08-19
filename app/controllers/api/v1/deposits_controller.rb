class Api::V1::DepositsController < ApplicationController
  before_action :authenticate_user!

  def index
    user_deposits = current_user.deposits.order(created_at: :desc)

    pagy, deposits = pagy(user_deposits, items: 15)
    pagy_headers_merge(pagy)
    render json: DepositSerializer.new(deposits).serializable_hash, status: :ok
  end

  def create
    service = CreateDepositService.new(current_user, deposit_params)
    service.call

    if service.success?
      serializer_options = { params: { gateway_response: service.instance_variable_get(:@mp_result) } }
      render json: DepositSerializer.new(service.deposit, serializer_options).serializable_hash, status: :created
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def show
    deposit = current_user.deposits.find(params[:id])
    render json: DepositSerializer.new(deposit).serializable_hash, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Deposit not found." }, status: :not_found
  end

  private

  def deposit_params
    params.require(:deposit).permit(:amount_in_cents, :bonus_code)
  end
end
