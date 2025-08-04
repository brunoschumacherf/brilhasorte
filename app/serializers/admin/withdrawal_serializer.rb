class Admin::WithdrawalSerializer
  include JSONAPI::Serializer

  attributes :id, :amount_in_cents, :status, :pix_key_type, :pix_key, :gateway_response, :created_at

  belongs_to :user, serializer: UserSerializer
end
