class Api::V1::WebhooksController < ApplicationController
  def pix_confirmation
    payload = JSON.parse(request.body.read)
    # O gateway de pagamento enviará o ID da transação que ele gerou.
    gateway_id = payload["gateway_transaction_id"]

    deposit = Deposit.find_by(gateway_transaction_id: gateway_id, status: :pending)

    if deposit
      user = deposit.user
      bonus_amount = 0

      if deposit.bonus_code
        bonus_code = deposit.bonus_code
        bonus_amount = (deposit.amount_in_cents * bonus_code.bonus_percentage).to_i
        bonus_code.increment!(:uses_count)
      end

      total_credit = deposit.amount_in_cents + bonus_amount

      ActiveRecord::Base.transaction do
        deposit.update!(status: :completed, bonus_in_cents: bonus_amount)
        user.increment!(:balance_in_cents, total_credit)
        if user.referrer.present? && !user.deposits.completed.where.not(id: deposit.id).exists?
          referrer = user.referrer
          reward_in_cents = 500 # TO DO DEFINE A REWARD AMOUNT IN DASHBOARD
          referrer.increment!(:balance_in_cents, reward_in_cents)
          puts "====== REFERRAL BONUS GRANTED ======"
          puts "User #{referrer.id} received #{reward_in_cents} cents for referring User #{user.id}"
        end
      end
      puts "====== DEPOSIT CONFIRMED ======"
      puts "Deposit #{deposit.id} confirmed for User #{deposit.user.id}."
    else
      puts "====== WEBHOOK WARNING ======"
      puts "Pending deposit not found for gateway_id: #{gateway_id}"
    end

    head :ok
  end
end
