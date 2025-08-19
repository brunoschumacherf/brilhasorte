class Api::V1::TowerGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_active_tower_game, only: [:play, :cash_out, :active_game]

  def create
    if current_user.tower_games.active.exists?
      return render json: { error: 'Você já tem um jogo ativo.' }, status: :unprocessable_entity
    end

    game = TowerGames::Create.new(user: current_user, params: create_params).call
    render json: TowerGameSerializer.new(game).serializable_hash, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def play
    game = TowerGames::Play.new(tower_game: @tower_game, choice_index: params[:choice_index]).call
    render json: TowerGameSerializer.new(game).serializable_hash, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def cash_out
    game = TowerGames::CashOut.new(tower_game: @tower_game).call
    render json: TowerGameSerializer.new(game).serializable_hash, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def active_game
    if @tower_game
      render json: TowerGameSerializer.new(@tower_game).serializable_hash, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  def tower
    render json: TOWER_GAME_CONFIG
  end

  private

  def set_active_tower_game
    @tower_game = current_user.tower_games.active.find_by(id: params[:id]) || current_user.tower_games.active.first
    render json: { error: 'Nenhum jogo ativo encontrado.' }, status: :not_found unless @tower_game
  end

  def create_params
    params.require(:tower_game).permit(:difficulty, :bet_amount_in_cents)
  end
end
