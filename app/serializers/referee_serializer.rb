class RefereeSerializer
  include JSONAPI::Serializer
  attributes :id, :full_name, :created_at

  attribute :has_deposited do |user|
    user.deposits.completed.exists?
  end
end
