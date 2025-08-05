class Api::V1::Admin::DashboardsController < Api::V1::Admin::BaseController
  def show
    period = params[:period] || 'all_time'
    date_range = case period.downcase
                 when 'daily'
                   Time.current.beginning_of_day..Time.current.end_of_day
                 when 'weekly'
                   Time.current.beginning_of_week..Time.current.end_of_week
                 when 'monthly'
                   Time.current.beginning_of_month..Time.current.end_of_month
                 else
                   nil
                 end

    # Aplica o filtro de data se um período for especificado
    games_scope = date_range ? Game.where(created_at: date_range) : Game.all
    deposits_scope = date_range ? Deposit.where(created_at: date_range) : Deposit.all
    users_scope = date_range ? User.where(created_at: date_range) : User.all

    # Métricas Financeiras
    total_deposited = deposits_scope.completed.sum(:amount_in_cents)
    total_won = games_scope.finished.sum(:winnings_in_cents)
    # GGR (Gross Gaming Revenue) = Total Apostado - Total Ganho
    total_spent_on_games = games_scope.joins(:scratch_card).sum('scratch_cards.price_in_cents')
    gross_gaming_revenue = total_spent_on_games - total_won

    # Métricas de Usuário
    new_users = users_scope.count
    total_users = User.count

    # Métricas de Atividade
    games_played = games_scope.count

    render json: {
      period: period,
      statistics: {
        total_deposited_in_cents: total_deposited,
        total_won_in_cents: total_won,
        total_spent_on_games_in_cents: total_spent_on_games,
        gross_gaming_revenue_in_cents: gross_gaming_revenue,
        new_users: new_users,
        total_users: total_users,
        games_played: games_played
      }
    }, status: :ok
  end
end
