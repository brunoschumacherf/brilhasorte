class Api::V1::WebhooksController < ApplicationController
  def pix_confirmation
    payload = JSON.parse(request.body.read)
    # O gateway de pagamento enviará o ID da transação que ele gerou.
    gateway_id = payload["gateway_transaction_id"]

    deposit = Deposit.find_by(gateway_transaction_id: gateway_id, status: :pending)

    if deposit
      ActiveRecord::Base.transaction do
        deposit.update!(status: :completed)
        deposit.user.increment!(:balance_in_cents, deposit.amount_in_cents)
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
