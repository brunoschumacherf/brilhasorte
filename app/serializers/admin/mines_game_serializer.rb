module Admin
  class MinesGameSerializer
    include JSONAPI::Serializer

    attributes :id, :bet_amount, :mines_count, :state, :payout_multiplier, :created_at

    belongs_to :user, serializer: Admin::UserSerializer
  end
end
