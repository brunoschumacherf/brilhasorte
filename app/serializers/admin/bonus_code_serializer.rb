class Admin::BonusCodeSerializer
  include JSONAPI::Serializer
  attributes :id, :code, :bonus_percentage, :expires_at, :max_uses, :uses_count, :is_active, :created_at
end
