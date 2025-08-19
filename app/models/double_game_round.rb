class DoubleGameRound < ApplicationRecord
  has_many :bets, class_name: 'DoubleGameBet', dependent: :destroy

  enum status: { betting: 0, spinning: 1, completed: 2 }

  validates :round_hash, presence: true

  # Garante que sempre haja uma rodada ativa para os jogadores entrarem.
  def self.ensure_active_round
    # Se não houver nenhuma rodada (jogo nunca começou) ou se a última já terminou, crie uma nova.
    unless betting.exists? || spinning.exists?
      round = create!(round_hash: SecureRandom.hex(16))
      round_data = round.as_json(include: { bets: { include: :user } })
      ActionCable.server.broadcast('double_game:main', { type: 'new_round', round: round_data })
    end
  end
end
