class Api::V1::DoubleGamesController < ApplicationController

  def place_bet
    round = DoubleGameRound.betting.first
    raise 'A fase de apostas está fechada.' unless round

    bet_amount_in_cents = params[:bet_amount_in_cents].to_i

    DoubleGameBet.transaction do
      current_user.lock!
      raise 'Saldo insuficiente.' if current_user.balance_in_cents < bet_amount_in_cents

      current_user.update!(balance_in_cents: current_user.balance_in_cents - bet_amount_in_cents)

      bet = round.bets.create!(
        user: current_user,
        bet_amount_in_cents: bet_amount_in_cents,
        color: params[:color]
      )

      ActionCable.server.broadcast('double_game:main', { type: 'new_bet', bet: bet.as_json(include: :user) })
    end

    render json: { success: true }, status: :created
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  def history
    rounds = DoubleGameRound.completed.order(created_at: :desc).limit(15)
    render json: DoubleGameRoundSerializer.new(rounds).serializable_hash
  end


  def trigger_draw
    DoubleGames::Cycle.new.call
    head :ok
  end
end
