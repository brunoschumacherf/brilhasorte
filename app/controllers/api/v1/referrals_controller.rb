class Api::V1::ReferralsController < ApplicationController
  before_action :authenticate_user!

  def index
    referred_users = current_user.referred_users.order(created_at: :desc)
    pagy, paginated_referred_users = pagy(referred_users, items: 20)

    pagy_headers_merge(pagy)

    render json: RefereeSerializer.new(paginated_referred_users).serializable_hash, status: :ok
  end
end
