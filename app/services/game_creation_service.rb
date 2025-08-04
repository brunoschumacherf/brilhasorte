class GameCreationService
  Result = Struct.new(:success?, :game, :error_message)

  def initialize(user, scratch_card)
    @user = user
    @scratch_card = scratch_card
  end

  def call
    @user.with_lock do
      ActiveRecord::Base.transaction do
        unless user_has_enough_balance?
          return Result.new(false, nil, "Saldo insuficiente")
        end

        prize = @scratch_card.draw_prize
        return Result.new(false, nil, "Não foi possível gerar o jogo. Tente novamente.") unless prize

        @user.decrement!(:balance_in_cents, @scratch_card.price_in_cents)

        prize.decrement!(:stock) if prize.stock != -1

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
    end
  rescue => e
    return Result.new(false, nil, e.message)
  end

  private

  def user_has_enough_balance?
    @user.balance_in_cents >= @scratch_card.price_in_cents
  end

end
