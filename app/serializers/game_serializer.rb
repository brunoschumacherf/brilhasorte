class GameSerializer
  include JSONAPI::Serializer
  attributes :id, :status, :game_hash, :created_at

  belongs_to :scratch_card
end
