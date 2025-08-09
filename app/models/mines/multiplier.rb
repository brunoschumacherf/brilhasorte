module Mines
  module Multiplier
    MULTIPLIERS = YAML.load_file(Rails.root.join('config/mines_multipliers.yml')).deep_symbolize_keys

    def self.for(mines_count:, revealed_count:)
      return "1.0" if revealed_count.zero?

      multipliers_for_mine_count = MULTIPLIERS[mines_count.to_i]
      return "1.0" unless multipliers_for_mine_count

      multipliers_for_mine_count[revealed_count.to_i] || "1.0"
    end
  end
end
