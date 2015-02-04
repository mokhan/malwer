class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    Publisher.publish("events", event_params)
    redirect_to events_path, notice: 'Event was successfully created.'
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  def event_params
    params.require(:event).permit(:name, :data)
  end
end
