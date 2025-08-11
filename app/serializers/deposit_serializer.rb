class DepositSerializer
  include JSONAPI::Serializer
  attributes :id, :amount_in_cents, :status, :created_at

  attribute :pix_qr_code_payload do |deposit, params|
    params[:gateway_response].dig(:response, "point_of_interaction", "transaction_data", "qr_code")
  end

  attribute :pix_qr_code_image_base64 do |deposit, params|
    base64_data = params[:gateway_response].dig(:response, "point_of_interaction", "transaction_data", "qr_code_base64")

    "data:image/png;base64,#{base64_data}" if base64_data.present?
  end
end
