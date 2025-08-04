class Api::V1::ReferralsController < ApplicationController
  before_action :authenticate_user!

  def index
    referees = current_user.referees.order(created_at: :desc)
    pagy, paginated_referees = pagy(referees, items: 20)

    pagy_headers_merge(pagy)

    render json: RefereeSerializer.new(paginated_referees).serializable_hash, status: :ok
  end
end
