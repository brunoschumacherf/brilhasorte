require "httparty"
require "openssl"

class EfipayWithdrawalService
  include HTTParty
  base_uri "https://pix.api.efipay.com.br" # Produção; para sandbox use https://sandbox.efipay.com.br

  def initialize
    @auth_service = EfipayAuthService.new
    @token = @auth_service.token["access_token"]
    @cert_path = Rails.root.join("config", "certs", "certificado.pem").to_s
  end

  # withdrawal_id: id interno do saque (para correlacionar com idEnvio)
  # amount_in_cents: valor em centavos
  # pix_key: chave Pix de destino
  def send_pix(withdrawal_id:, amount_in_cents:, pix_key:)
    body = {
      valor: format("%.2f", amount_in_cents.to_f / 100), # ex: 1000 -> "10.00"
      favorecido: {
        chave: pix_key
      }
    }

    options = {
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@token}"
      },
      body: body.to_json,
      ssl_cert: OpenSSL::X509::Certificate.new(File.read(@cert_path)),
      ssl_key: OpenSSL::PKey::RSA.new(File.read(@cert_path))
    }

    response = self.class.put("/v2/pix/#{withdrawal_id}", options)

    if response.success?
      response.parsed_response
    else
      raise "Erro ao enviar Pix: #{response.body}"
    end
  end
end
