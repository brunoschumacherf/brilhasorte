
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :full_name, :cpf, :birth_date, :phone_number, :balance_in_cents, :created_at, :referral_code
end
