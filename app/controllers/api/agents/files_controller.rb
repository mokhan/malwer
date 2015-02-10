module Api
  module Agents
    class FilesController < ApplicationController
      before_action do
        request.format = :json
      end

      def show
        @agent = Agent.find(params[:agent_id])
        @fingerprint = params[:id]
        @file = Disposition.find_by(fingerprint: params[:id])
        publish(EventMessage.new(
          agent_id: @agent.id,
          event_type: :scanned,
          data: params[:data]
        ))
      end
    end
  end
end
