class GameSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :game_hash, :created_at, :winnings_in_cents

  attribute :server_seed, if: Proc.new { |record, params|
    params && params[:reveal_secrets] == true
  }

  belongs_to :scratch_card

  belongs_to :prize
end
