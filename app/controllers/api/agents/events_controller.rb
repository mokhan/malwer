module Api
  module Agents
    class EventsController < ApiController
      def create
        @agent = Agent.find(params[:agent_id])
        publish(EventMessage.new(
          agent_id: @agent.id,
          event_type: event_params[:type],
          data: event_params[:data]
        ))

        render nothing: true
      end

      private

      def event_params
        params[:event]
      end
    end
  end
end
