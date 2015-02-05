module Agents
  class EventsController < ApplicationController
    before_action :load_agent

    def index
      @events = @agent.events.order(created_at: :desc)
    end

    def new
      @event = Event.new
    end

    def create
      Publisher.publish("events", event_params.merge({agent_id: @agent.id}))
      redirect_to agent_events_url, notice: 'Event was successfully created.'
    end

    def destroy
      @event = Event.find(params[:id])
      @event.destroy
      redirect_to agent_events_url(@agent), notice: 'Event was successfully destroyed.'
    end

    private

    def event_params
      params[:event]
    end

    def load_agent
      @agent = Agent.find(params[:agent_id])
    end
  end
end
