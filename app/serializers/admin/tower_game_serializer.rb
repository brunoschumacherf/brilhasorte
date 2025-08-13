class Admin::TowerGameSerializer
  include JSONAPI::Serializer
  attributes :id, :difficulty, :bet_amount_in_cents, :status, :current_level,
             :payout_multiplier, :winnings_in_cents, :created_at

  belongs_to :user, serializer: Admin::UserSerializer
end
