class GameSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :game_hash, :created_at, :winnings_in_cents

  attribute :server_seed, if: Proc.new { |record, params|
    params && params[:reveal_secrets] == true
  }

  # --- CORREÇÃO AQUI ---
  # Adicionamos os nomes do prêmio e da raspadinha diretamente nos atributos.
  # O '&.' (safe navigation operator) evita erros caso a relação não exista.
  attribute :prize do |game|
    {
      name: game.prize&.name
    }
  end

  attribute :scratch_card do |game|
    {
      name: game.scratch_card&.name
    }
  end

  # Mantemos as relações para consistência, mas não dependeremos mais do `included`
  belongs_to :scratch_card
  belongs_to :prize
end
