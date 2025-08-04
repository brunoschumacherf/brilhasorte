class Admin::GameSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :winnings_in_cents, :game_hash, :server_seed, :created_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :prize, serializer: PrizeSerializer
  belongs_to :scratch_card, serializer: ScratchCardSerializer
end
