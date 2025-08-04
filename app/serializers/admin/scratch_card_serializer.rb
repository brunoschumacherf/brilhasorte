class Admin::ScratchCardSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :price_in_cents, :description, :image_url, :is_active

  has_many :prizes, serializer: Admin::PrizeSerializer
end
