class Api::V1::RankingsController < ApplicationController

  skip_before_action :authenticate_user!

  def index
    period = params[:period] || 'weekly'
    start_date = case period.downcase
                 when 'daily'
                   Time.current.beginning_of_day
                 when 'monthly'
                   Time.current.beginning_of_month
                 when 'all_time'
                   nil # Sem data de início para o ranking geral
                 else
                   Time.current.beginning_of_week
                 end


    query = Game.joins(:user)
                .where('games.winnings_in_cents > 0')
                .group('users.id')
                .select('users.id, users.full_name, SUM(games.winnings_in_cents) as total_winnings')
                .order('total_winnings DESC')
                .limit(20)

    if start_date
      query = query.where('games.created_at >= ?', start_date)
    end

    render json: {
      period: period,
      ranking: query.as_json(except: :id)
    }, status: :ok
  end
end
