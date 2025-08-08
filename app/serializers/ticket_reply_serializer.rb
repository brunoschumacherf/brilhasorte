class TicketReplySerializer
  include JSONAPI::Serializer
  attributes :id, :message, :created_at
  belongs_to :user, serializer: UserSerializer
end
