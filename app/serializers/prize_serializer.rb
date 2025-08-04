class PrizeSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :value_in_cents, :image_url
end
