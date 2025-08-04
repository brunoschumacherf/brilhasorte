class ScratchCardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :price_in_cents, :description, :image_url

  has_many :prizes
end
