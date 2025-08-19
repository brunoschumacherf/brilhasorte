class Admin::DoubleGameRoundSerializer
  include JSONAPI::Serializer
  attributes :id, :status, :winning_color, :created_at
  has_many :bets, serializer: Admin::DoubleGameBetSerializer
end
