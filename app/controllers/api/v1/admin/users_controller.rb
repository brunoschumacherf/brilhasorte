class Api::V1::Admin::UsersController < Api::V1::Admin::BaseController
  def index
    @q = User.ransack(params[:q])
    pagy, users = pagy(@q.result.order(created_at: :desc), items: 20)

    pagy_headers_merge(pagy)
    render json: Admin::UserSerializer.new(users).serializable_hash, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: Admin::UserSerializer.new(user).serializable_hash, status: :ok
  end
end
