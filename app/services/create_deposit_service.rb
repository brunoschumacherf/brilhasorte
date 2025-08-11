# app/services/create_deposit_service.rb

class CreateDepositService
  attr_reader :deposit, :errors

  def initialize(user, params)
    @user = user
    @params = params
    @bonus_code_str = params[:bonus_code]&.upcase
    @errors = []
  end

  def call
    validate_bonus_code
    return self unless success?

    create_mercadopago_payment
    return self unless success?

    create_local_deposit

    self
  end

  def success?
    @errors.empty?
  end

  private


  def validate_bonus_code
    return if @bonus_code_str.blank?

    @bonus_code = find_valid_bonus_code(@bonus_code_str)

    if @bonus_code.nil?
      @errors << "Código de bônus inválido ou expirado."
    elsif @user.deposits.where(bonus_code: @bonus_code, status: :completed).exists?
      @errors << "Você já utilizou este código de bônus."
    end
  end



  def find_valid_bonus_code(code_str)
    code = BonusCode.find_by(code: code_str)

    return nil unless code&.is_active
    return nil if code.expires_at && code.expires_at < Time.current
    return nil if code.max_uses != -1 && code.uses_count >= code.max_uses

    code
  end



  def create_mercadopago_payment
    sdk = Mercadopago::SDK.new(ENV['MP_ACCESS_TOKEN'])
    @mp_result = sdk.payment.create(payment_data_payload)

    payment = @mp_result[:response]
    unless (@mp_result[:status] == 201 || (payment && payment["status"] == "pending"))
      @errors << "Falha ao processar o pagamento. Por favor, tente novamente."
      Rails.logger.error "MercadoPago Error: #{@mp_result}"
    end
  rescue StandardError => e
    Rails.logger.error "MercadoPago SDK Error: #{e.message}"
    @errors << "Ocorreu um erro de comunicação com o provedor de pagamento."
  end

  def create_local_deposit
    @deposit = @user.deposits.new(
      amount_in_cents: @params[:amount_in_cents],
      status: :pending,
      gateway_transaction_id: @mp_result.dig(:response, 'id'),
      bonus_code: @bonus_code
    )

    @errors.concat(@deposit.errors.full_messages) unless @deposit.save
  end

  def payment_data_payload
    {
      transaction_amount: @params[:amount_in_cents] / 100.0,
      description: "Depósito para #{@user.email}",
      payment_method_id: "pix",
      payer: {
        email: @user.email,
        first_name: @user.full_name.split.first,
        last_name: @user.full_name.split.last
      }
    }
  end
end
