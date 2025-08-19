# app/serializers/tower_game_serializer.rb
class TowerGameSerializer
  include JSONAPI::Serializer
  attributes :id, :difficulty, :bet_amount_in_cents, :status, :current_level,
             :payout_multiplier, :winnings_in_cents, :created_at

  attribute :current_winnings do |object|
    object.current_winnings
  end

  attribute :next_potential_winnings do |object|
    object.next_potential_winnings unless object.lost? || object.cashed_out?
  end

  attribute :revealed_level do |object|
    if object.lost?
      object.levels_layout[object.current_level]
    end
  end

  attribute :player_choices do |object|
    object.player_choices
  end
end
