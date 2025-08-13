class LimboGameSerializer
  include JSONAPI::Serializer
  attributes :id, :bet_amount_in_cents, :target_multiplier, :result_multiplier,
             :winnings_in_cents, :status, :created_at
end
