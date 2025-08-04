class WithdrawalSerializer
  include JSONAPI::Serializer
  attributes :id, :amount_in_cents, :status, :pix_key_type, :pix_key, :created_at
end
