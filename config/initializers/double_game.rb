require 'yaml'

DOUBLE_GAME_CONFIG = begin
  config_path = Rails.root.join('config', 'double_game.yml')
  YAML.load_file(config_path).deep_symbolize_keys
rescue StandardError => e
  Rails.logger.error "Erro ao carregar double_game.yml: #{e.message}"
  {}
end
