class TicketReply < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :message, presence: true
end
