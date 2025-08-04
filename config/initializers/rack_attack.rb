class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new


  throttle('logins/ip', limit: 5, period: 1.minute) do |req|
    if req.path == '/login' && req.post?
      req.ip
    end
  end


  throttle('logins/email', limit: 5, period: 1.minute) do |req|
    if req.path == '/login' && req.post?
      req.params['user']&.[]('email')&.downcase&.strip
    end
  end


  throttle('games/user', limit: 20, period: 1.minute) do |req|
    if req.path == '/api/v1/games' && req.post?
      token = req.env['HTTP_AUTHORIZATION'].to_s.split(' ').last
      if token.present?
        begin
          decoded_token = Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
          decoded_token['sub']
        rescue => e
          nil
        end
      end
    end
  end


  throttle('req/ip', limit: 60, period: 1.minute) do |req|
    req.ip
  end
end
