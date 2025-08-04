class Api::V1::GamesController < ApplicationController
  before_action :authenticate_user!

  def create
    scratch_card = ScratchCard.find(params[:scratch_card_id])
    result = GameCreationService.new(current_user, scratch_card).call

    if result.success?
      # Criamos um Serializer para não expor dados sensíveis como o prêmio ou o seed.
      render json: GameSerializer.new(result.game).serializable_hash, status: :created
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end
end
