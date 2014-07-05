class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :resolve]
  before_filter :require_legitbs, only: %i{ resolve }

  # GET /tickets
  def index
    @tickets = ticket_scope.order(created_at: :desc)
    if params[:scope] != 'all'
      @tickets = @tickets.unresolved
    end
  end

  # GET /tickets/1
  def show
  end

  # GET /tickets/new
  def new
    @ticket = current_team.tickets.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  def create
    @ticket = current_team.tickets.new(ticket_params)

    if @ticket.save
      redirect_to @ticket, notice: 'Ticket was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  def resolve
    @ticket.resolve!
    redirect_to tickets_path
  end

  def unresolve
    @ticket.unresolve!
    redirect_to tickets_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = ticket_scope.find(params[:id])
    end

    def ticket_scope
      if is_legitbs?
        Ticket
      else
        current_team.tickets
      end
    end
    
    # Only allow a trusted parameter "white list" through.
    def ticket_params
      params.require(:ticket).permit(:body)
    end
end
