# app/services/game_creation_service.rb
class GameCreationService
  Result = Struct.new(:success?, :game, :error_message)

  def initialize(user, scratch_card)
    @user = user
    @scratch_card = scratch_card
  end

  def call
    ActiveRecord::Base.transaction do
      # 1. Verificar Saldo
      unless user_has_enough_balance?
        raise ActiveRecord::Rollback, "Insufficient funds"
      end
      @user.decrement!(:balance_in_cents, @scratch_card.price_in_cents)
      prize = draw_prize
      server_seed = SecureRandom.hex(16)
      game_hash = Digest::SHA256.hexdigest("#{server_seed}-#{prize.id}")
      game = Game.create!(
        user: @user,
        scratch_card: @scratch_card,
        prize: prize,
        server_seed: server_seed,
        game_hash: game_hash,
        status: :pending
      )
      return Result.new(true, game, nil)
    end
  rescue ActiveRecord::Rollback => e
    return Result.new(false, nil, e.message)
  end

  private

  def user_has_enough_balance?
    @user.balance_in_cents >= @scratch_card.price_in_cents
  end

  def draw_prize
    prizes = @scratch_card.prizes
    weighted_prizes = prizes.flat_map { |p| [p] * (p.probability * 1000).to_i }
    weighted_prizes.sample
  end
end
