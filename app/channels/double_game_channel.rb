# app/channels/double_game_channel.rb
class DoubleGameChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'double_game:main'

    # CORREÇÃO: Usar o nome do método correto que existe no model.
    DoubleGameRound.ensure_active_round

    # Envia o estado atual para o novo usuário conectado
    round = DoubleGameRound.betting.first || DoubleGameRound.spinning.first
    transmit({ type: 'current_state', round: round.as_json(include: { bets: { include: :user } }) }) if round
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
