class Api::V1::Admin::ScratchCardsController < Api::V1::Admin::BaseController
  before_action :set_scratch_card, only: [:show, :update, :destroy]

  def index
    @q = ScratchCard.includes(:prizes).ransack(params[:q])
    pagy, scratch_cards = pagy(@q.result.order(created_at: :desc))
    pagy_headers_merge(pagy)
    render json: Admin::ScratchCardSerializer.new(scratch_cards).serializable_hash
  end

  def show
    render json: Admin::ScratchCardSerializer.new(@scratch_card, include: [:prizes]).serializable_hash
  end

  def create
    @scratch_card = ScratchCard.new(scratch_card_params)
    if @scratch_card.save
      AuditLoggerService.new.call(user: current_user, action: 'admin.scratch_card.create', auditable_object: @scratch_card)
      render json: Admin::ScratchCardSerializer.new(@scratch_card).serializable_hash, status: :created
    else
      render json: { errors: @scratch_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @scratch_card.update(scratch_card_params)
      AuditLoggerService.new.call(user: current_user, action: 'admin.scratch_card.update', auditable_object: @scratch_card)
      render json: Admin::ScratchCardSerializer.new(@scratch_card).serializable_hash
    else
      render json: { errors: @scratch_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @scratch_card.destroy
    AuditLoggerService.new.call(user: current_user, action: 'admin.scratch_card.destroy', auditable_object: @scratch_card)
    head :no_content
  end

  private

  def set_scratch_card
    @scratch_card = ScratchCard.includes(:prizes).find(params[:id])
  end

  def scratch_card_params
    params.require(:scratch_card).permit(
      :name, :price_in_cents, :description, :image_url, :is_active,
      prizes_attributes: [:id, :name, :value_in_cents, :probability, :stock, :image_url, :_destroy]
    )
  end
end
