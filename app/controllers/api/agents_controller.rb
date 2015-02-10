module Api
  class AgentsController < ApiController
    def create
      @agent = Agent.create!(agent_params)
    end

    def agent_params
      params.require(:agent).permit(:hostname)
    end
  end
end
