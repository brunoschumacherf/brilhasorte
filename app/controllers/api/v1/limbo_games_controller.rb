class Api::V1::LimboGamesController < ApplicationController
  before_action :authenticate_user!

  def create
    game = LimboGames::Play.new(user: current_user, params: game_params).call
    render json: LimboGameSerializer.new(game).serializable_hash, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def history
    games = LimboGame.latest_for_user(current_user)
    render json: LimboGameSerializer.new(games).serializable_hash, status: :ok
  end

  private

  def game_params
    params.require(:limbo_game).permit(:bet_amount_in_cents, :target_multiplier)
  end
end
