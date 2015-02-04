module Agents
  class FilesController < ApplicationController
    before_action :load_agent
    before_action do
      request.format = :json
    end

    def index
    end

    def show
      @file = Disposition.find_by(fingerprint: params[:id])
      Publisher.publish("queries", {
        fingerprint: params[:id],
        data: params
      })
    end

    private

    def load_agent
      Agent.find(params[:agent_id])
    end
  end
end
