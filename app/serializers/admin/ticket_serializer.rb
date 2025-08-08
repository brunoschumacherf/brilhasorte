class Admin::TicketSerializer
  include JSONAPI::Serializer
  attributes :id, :ticket_number, :subject, :status, :created_at
  belongs_to :user, serializer: Admin::UserSerializer
  has_many :ticket_replies, serializer: Admin::TicketReplySerializer
end
