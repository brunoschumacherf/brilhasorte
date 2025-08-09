module Mines
  class RevealTileService
    def initialize(game:, row:, col:)
      @game = game
      @row = row.to_i
      @col = col.to_i
    end

    def call
      return ServiceResult.new(success: false, errors: ['Posição já revelada']) if already_revealed?

      if is_mine?
        game.update!(state: 'busted')
        ServiceResult.new(success: true, payload: { status: 'game_over', game: game })
      else
        update_game_with_diamond
        ServiceResult.new(success: true, payload: { status: 'safe', game: game })
      end
    end

    private

    attr_reader :game, :row, :col

    def already_revealed?
      game.revealed_tiles.any? { |tile| tile['row'] == row && tile['col'] == col }
    end

    def is_mine?
      game.grid[row][col] == 'mine'
    end

    def update_game_with_diamond
      new_revealed_tiles = game.revealed_tiles + [{ 'row' => row, 'col' => col }]

      new_multiplier_str = Mines::Multiplier.for(
        mines_count: game.mines_count,
        revealed_count: new_revealed_tiles.count
      )

      game.update!(
        revealed_tiles: new_revealed_tiles,
        payout_multiplier: new_multiplier_str
      )
    end
  end
end
