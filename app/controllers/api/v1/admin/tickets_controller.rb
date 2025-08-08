class Api::V1::Admin::TicketsController < Api::V1::Admin::BaseController
  before_action :set_ticket, only: [:show, :create_reply]

  def index
    @q = Ticket.includes(:user).ransack(params[:q])
    pagy, tickets = pagy(@q.result.order(created_at: :desc))
    pagy_headers_merge(pagy)
    render json: Admin::TicketSerializer.new(tickets).serializable_hash, status: :ok
  end

  def show
    options = { include: [:ticket_replies, 'ticket_replies.user', :user] }
    render json: Admin::TicketSerializer.new(@ticket, options).serializable_hash, status: :ok
  end

  def create_reply
    reply = @ticket.ticket_replies.new(user: current_user, message: reply_params[:message])

    if reply.save
      status_to_set = reply_params[:close_ticket] ? :closed : :admin_reply
      @ticket.update(status: status_to_set)
      render json: Admin::TicketReplySerializer.new(reply).serializable_hash, status: :created
    else
      render json: { errors: reply.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find_by!(ticket_number: params[:ticket_number])
  end

  def reply_params
    params.require(:reply).permit(:message, :close_ticket)
  end
end
