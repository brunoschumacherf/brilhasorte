class Admin::PrizeSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :value_in_cents, :probability, :stock, :image_url
end
