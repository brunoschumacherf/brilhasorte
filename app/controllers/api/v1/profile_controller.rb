class Api::V1::ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: UserSerializer.new(current_user).serializable_hash, status: :ok
  end

  def update
    if current_user.update(profile_params)
      render json: UserSerializer.new(current_user).serializable_hash, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:full_name, :cpf, :birth_date, :phone_number)
  end
end
