class MinesGameSerializer
  include JSONAPI::Serializer

  attributes :id,
             :created_at,
             :bet_amount,
             :mines_count,
             :state,
             :payout_multiplier,
             :revealed_tiles,
             :updated_at,
             :user_id,
             :next_multiplier,
             :grid_reveal

end
