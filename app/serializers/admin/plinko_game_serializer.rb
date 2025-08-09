module Admin
  class PlinkoGameSerializer
    include JSONAPI::Serializer

    set_type :plinko_game

    attributes :id, :bet_amount, :rows, :risk, :multiplier, :winnings, :created_at

    belongs_to :user, serializer: ::Admin::UserSerializer
  end
end
