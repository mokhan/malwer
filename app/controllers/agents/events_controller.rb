module Agents
  class EventsController < ApplicationController
    before_action :load_agent

    def index
      @events = Event.all
    end

    def new
      @event = Event.new
    end

    def create
      Publisher.publish("events", event_params.merge({agent_id: @agent.id}))
      redirect_to agent_events_path, notice: 'Event was successfully created.'
    end

    def destroy
      @event = Event.find(params[:id])
      @event.destroy
      redirect_to events_url, notice: 'Event was successfully destroyed.'
    end

    private

    def event_params
      params.require(:event).permit(:name, :data)
    end

    def load_agent
      @agent = Agent.find(params[:agent_id])
    end
  end
end
