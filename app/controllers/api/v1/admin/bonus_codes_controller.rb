# app/controllers/api/v1/admin/bonus_codes_controller.rb
class Api::V1::Admin::BonusCodesController < Api::V1::Admin::BaseController
  before_action :set_bonus_code, only: [:show, :update, :destroy]

  def index
    @q = BonusCode.ransack(params[:q])
    pagy, bonus_codes = pagy(@q.result.order(created_at: :desc))

    pagy_headers_merge(pagy)
    render json: Admin::BonusCodeSerializer.new(bonus_codes).serializable_hash
  end

  def show
    render json: Admin::BonusCodeSerializer.new(@bonus_code).serializable_hash
  end

  def create
    @bonus_code = BonusCode.new(bonus_code_params)

    if @bonus_code.save
      AuditLoggerService.new.call(user: current_user, action: 'admin.bonus_code.create', auditable_object: @bonus_code)
      render json: Admin::BonusCodeSerializer.new(@bonus_code).serializable_hash, status: :created
    else
      render json: { errors: @bonus_code.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @bonus_code.update(bonus_code_params)
      AuditLoggerService.new.call(user: current_user, action: 'admin.bonus_code.update', auditable_object: @bonus_code)
      render json: Admin::BonusCodeSerializer.new(@bonus_code).serializable_hash
    else
      render json: { errors: @bonus_code.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @bonus_code.destroy
    AuditLoggerService.new.call(user: current_user, action: 'admin.bonus_code.destroy', auditable_object: @bonus_code)
    head :no_content
  end

  private

  def set_bonus_code
    @bonus_code = BonusCode.find(params[:id])
  end

  def bonus_code_params
    params.require(:bonus_code).permit(:code, :bonus_percentage, :expires_at, :max_uses, :is_active)
  end
end
