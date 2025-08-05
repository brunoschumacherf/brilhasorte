Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Permite que seu frontend React (rodando em localhost:5173) faça requisições
    origins 'http://localhost:5173'

    resource '*',
      headers: :any,
      # Expõe o header 'Authorization' para que o frontend consiga ler o token JWT
      expose: ['Authorization'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
