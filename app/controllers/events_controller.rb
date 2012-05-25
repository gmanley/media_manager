class EventsController < ApplicationController
  respond_to :html, :json

  def index
    @events = Event.page(params[:page]).per(50).asc(:name)

    respond_with(@events)
  end

  def show
    @event = Event.find(params[:id])

    respond_with(@event)
  end

  def new
    @event = Event.new(params[:event])

    respond_with(@event)
  end

  def edit
    @event = Event.find(params[:id])

    respond_with(@event)
  end

  def create
    @event = Event.create(params[:event])

    respond_with(@event)
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])

    respond_with(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_with(@event)
  end
end