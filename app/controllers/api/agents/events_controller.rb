module Api
  module Agents
    class EventsController < ApplicationController
      def create
        @agent = Agent.find(params[:agent_id])
        message = event_params.merge({agent_id: @agent.id})
        routing_key = "events.#{event_params[:type]}.#{@agent.id}"
        Publisher.publish(routing_key, message)
        render nothing: true
      end

      private

      def event_params
        params[:event]
      end
    end
  end
end
