class Api::V1::GameSettingsController < ApplicationController
  def tower
    render json: TOWER_GAME_CONFIG
  end
end
