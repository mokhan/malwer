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
        message = {
          agent_id: @agent.id,
          type: :lookup,
          data: params[:data]
        }
        Publisher.publish("events.scanned.#{@agent.id}", message)
      end
    end
  end
end
