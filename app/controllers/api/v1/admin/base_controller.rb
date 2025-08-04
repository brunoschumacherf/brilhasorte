class Api::V1::Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  private

  def ensure_admin!
    unless current_user.admin?
      render json: { error: 'Acesso não autorizado.' }, status: :forbidden
    end
  end
end
