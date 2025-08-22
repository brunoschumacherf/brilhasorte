require "httparty"
require "openssl"

class EfipayAuthService
  include HTTParty
  base_uri "https://pix.api.efipay.com.br"

  def initialize
    @client_id = ENV["EFIPAY_CLIENT_ID"]
    @client_secret = ENV["EFIPAY_CLIENT_SECRET"]
    @cert_path = Rails.root.join("config", "certs", "certificado.pem").to_s
  end

  def token
    options = {
      body: { grant_type: "client_credentials" }.to_json,
      basic_auth: {
        username: @client_id,
        password: @client_secret
      },
      headers: { "Content-Type" => "application/json" },
      ssl_cert: OpenSSL::X509::Certificate.new(File.read(@cert_path)),
      ssl_key: OpenSSL::PKey::RSA.new(File.read(@cert_path))
    }

    response = self.class.post("/oauth/token", options)

    if response.success?
      response.parsed_response # retorna { "access_token" => "...", "token_type" => "Bearer", "expires_in" => ... }
    else
      raise "Erro ao autenticar: #{response.body}"
    end
  end
end
