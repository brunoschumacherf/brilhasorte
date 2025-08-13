class DoubleGameRoundSerializer
  include JSONAPI::Serializer
  attributes :id, :winning_color, :status, :created_at
end
