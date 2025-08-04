class Api::V1::ScratchCardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @scratch_cards = ScratchCard.where(is_active: true).order(:price_in_cents)
    render json: ScratchCardSerializer.new(@scratch_cards, include: [:prizes]).serializable_hash, status: :ok
  end
end
