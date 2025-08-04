class Api::V1::DepositsController < ApplicationController
  before_action :authenticate_user!

  def index
    user_deposits = current_user.deposits.order(created_at: :desc)

    pagy, deposits = pagy(user_deposits, items: 15)
    pagy_headers_merge(pagy)
    render json: DepositSerializer.new(deposits).serializable_hash, status: :ok
  end

  def create
    deposit_params = params.require(:deposit).permit(:amount_in_cents, :bonus_code)
    bonus_code_str = deposit_params[:bonus_code]&.upcase
    bonus_code = find_valid_bonus_code(bonus_code_str)

    if bonus_code && current_user.deposits.where(bonus_code: bonus_code, status: :completed).exists?
      render json: { error: "Você já utilizou este código de bônus." }, status: :unprocessable_entity
      return
    end

    gateway_id = "dep_#{SecureRandom.hex(10)}"
    deposit = current_user.deposits.new(
      amount_in_cents: deposit_params[:amount_in_cents],
      status: :pending,
      gateway_transaction_id: gateway_id,
      bonus_code: bonus_code
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

  private
  def find_valid_bonus_code(code_str)
    return nil if code_str.blank?

    code = BonusCode.find_by(code: code_str)
    return nil unless code&.is_active

    # Verifica se o código expirou
    return nil if code.expires_at && code.expires_at < Time.current

    # Verifica se o limite de usos foi atingido
    return nil if code.max_uses != -1 && code.uses_count >= code.max_uses

    code
  end
end
