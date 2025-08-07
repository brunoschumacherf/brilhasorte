class GameCreationService
  Result = Struct.new(:success?, :game, :error_message, :user)

  def initialize(user, scratch_card)
    @user = user
    @scratch_card = scratch_card
  end

  def call
    # O bloco with_lock inicia uma transação e bloqueia a linha do usuário no banco,
    # garantindo que nenhuma outra operação possa modificar o saldo ao mesmo tempo.
    @user.with_lock do
      unless user_has_enough_balance?
        return Result.new(false, nil, "Saldo insuficiente", @user)
      end

      prize = @scratch_card.draw_prize
      return Result.new(false, nil, "Não foi possível gerar o jogo. Tente novamente.", @user) unless prize

      # Usamos update! para garantir que a transação falhe se a atualização do saldo não funcionar.
      @user.update!(balance_in_cents: @user.balance_in_cents - @scratch_card.price_in_cents)

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

      return Result.new(true, game, nil, @user)
    end
  rescue ActiveRecord::RecordInvalid => e
    return Result.new(false, nil, e.message, @user)
  rescue => e
    Rails.logger.error "GameCreationService failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    return Result.new(false, nil, "Ocorreu um erro inesperado.", @user)
  end

  private

  def user_has_enough_balance?
    # Recarrega o usuário para garantir que estamos lendo o saldo mais recente
    # dentro do bloco with_lock.
    @user.reload
    @user.balance_in_cents >= @scratch_card.price_in_cents
  end
end
