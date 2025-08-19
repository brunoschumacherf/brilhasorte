# app/jobs/start_spin_job.rb
class StartSpinJob < ApplicationJob
  queue_as :default

  def perform(round_id)
    round = DoubleGameRound.find_by(id: round_id)
    unless round&.betting?
      Rails.logger.info "StartSpinJob: Rodada ##{round_id} não encontrada ou não está mais em fase de apostas. Ignorando."
      return
    end

    round.update!(status: :spinning)
    winning_color = determine_winning_color
    round.update!(winning_color: winning_color)

    ActionCable.server.broadcast('double_game:main', { type: 'spinning', winning_color: winning_color })

    FinishDoubleRoundJob.set(wait: DOUBLE_GAME_CONFIG[:spinning_duration].seconds).perform_later(round.id)
  end

  private

  def determine_winning_color
    roll = rand * 100
    cumulative_prob = 0
    DOUBLE_GAME_CONFIG[:probabilities].each do |color, prob|
      cumulative_prob += prob
      return color.to_s if roll < cumulative_prob
    end
    DOUBLE_GAME_CONFIG[:probabilities].keys.last.to_s
  end
end
