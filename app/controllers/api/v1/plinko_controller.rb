module Api
  module V1
    class PlinkoController < ApplicationController
      before_action :authenticate_user!

      def create
        service = Plinko::PlayService.new(
          user: current_user,
          bet_amount: params[:bet_amount],
          rows: params[:rows],
          risk: params[:risk]
        )
        result = service.call

        if result.success?
          render json: result.payload, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def multipliers
        render json: Plinko::PlayService::MULTIPLIERS
      end
    end
  end
end
