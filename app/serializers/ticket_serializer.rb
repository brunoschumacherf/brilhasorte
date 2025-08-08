class TicketSerializer
  include JSONAPI::Serializer
  attributes :id, :ticket_number, :subject, :status, :created_at
  has_many :ticket_replies
end
