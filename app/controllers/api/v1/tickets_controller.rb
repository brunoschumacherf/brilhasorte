class Api::V1::TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: [:show, :create_reply]

  def index
    pagy, tickets = pagy(current_user.tickets.order(created_at: :desc))
    pagy_headers_merge(pagy)
    render json: TicketSerializer.new(tickets).serializable_hash, status: :ok
  end

  def show
    puts @ticket.inspect
    options = { include: [:ticket_replies, 'ticket_replies.user'] }
    render json: TicketSerializer.new(@ticket, options).serializable_hash, status: :ok
  end

  def create
    ticket = current_user.tickets.new(subject: ticket_params[:subject])

    if ticket.save
      ticket.ticket_replies.create(user: current_user, message: ticket_params[:message])
      render json: TicketSerializer.new(ticket).serializable_hash, status: :created
    else
      render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_reply
    reply = @ticket.ticket_replies.new(user: current_user, message: reply_params[:message])

    if reply.save
      @ticket.update(status: :client_reply) # Atualiza o status
      render json: TicketReplySerializer.new(reply).serializable_hash, status: :created
    else
      render json: { errors: reply.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_ticket
    @ticket = current_user.tickets.find_by(ticket_number: params[:ticket_number])
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :message)
  end

  def reply_params
    params.require(:reply).permit(:message)
  end
end
