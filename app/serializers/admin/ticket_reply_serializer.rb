class Admin::TicketReplySerializer
  include JSONAPI::Serializer
  attributes :id, :message, :created_at
  belongs_to :user, serializer: Admin::UserSerializer
end
