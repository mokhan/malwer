module Agents
  class FilesController < ApplicationController
    before_action :load_agent

    def index
      @documents = @agent.files
    end

    private

    def load_agent
      @agent = Agent.find(params[:agent_id])
    end
  end
end
