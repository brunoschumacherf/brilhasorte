class Ticket < ApplicationRecord
  belongs_to :user
  has_many :ticket_replies, dependent: :destroy

  enum status: { open: 0, client_reply: 1, admin_reply: 2, closed: 3 }

  validates :subject, :status, presence: true
  has_one :initial_message, -> { order(created_at: :asc) }, class_name: 'TicketReply'

  before_validation :generate_ticket_number, on: :create

  private

  def generate_ticket_number
    loop do
      self.ticket_number = "BS-#{SecureRandom.hex(4).upcase}"
      break unless Ticket.exists?(ticket_number: self.ticket_number)
    end
  end
end
