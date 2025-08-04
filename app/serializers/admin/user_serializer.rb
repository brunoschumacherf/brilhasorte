class Admin::UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :full_name, :cpf, :birth_date, :phone_number,
             :balance_in_cents, :referral_code, :admin,
             :created_at, :updated_at

  belongs_to :referrer, serializer: UserSerializer # Mostra quem indicou este usuário

  attribute :games_count do |user|
    user.games.count
  end

  attribute :deposits_count do |user|
    user.deposits.completed.count
  end
end
