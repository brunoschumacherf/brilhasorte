class DepositSerializer
  include JSONAPI::Serializer
  attributes :id, :amount_in_cents, :status, :created_at

  attribute :pix_qr_code_payload do |object|
    '00020126580014br.gov.bcb.pix0136...COPIA_E_COLA_FALSO...5303986540510.005802BR5913NOME DO RECEBEDOR6008BRASILIA62070503***6304E2B1'
  end

  attribute :pix_qr_code_image_base64 do |object|
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII='
  end
end
