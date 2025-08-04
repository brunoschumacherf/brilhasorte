class Admin::DepositSerializer
  include JSONAPI::Serializer

  attributes :id, :amount_in_cents, :bonus_in_cents, :status, :gateway_transaction_id, :created_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :bonus_code, serializer: Admin::BonusCodeSerializer, if: Proc.new { |record| record.bonus_code.present? }
end
