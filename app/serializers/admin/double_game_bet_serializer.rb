class Admin::DoubleGameBetSerializer
  include JSONAPI::Serializer
  attributes :id, :bet_amount_in_cents, :color, :status, :winnings_in_cents
  belongs_to :user, serializer: Admin::UserSerializer
end
