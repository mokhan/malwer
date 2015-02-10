module Api
  class AgentsController < ApplicationController
    #before_action do
      #request.format = :json
    #end

    def create
      @agent = Agent.create!(agent_params)
    end

    def agent_params
      params.require(:agent).permit(:hostname)
    end
  end
end
