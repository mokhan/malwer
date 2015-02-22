module Api
  class ApiController < ActionController::Base
    protect_from_forgery with: :null_session
    protected

    def publish(message)
      Publisher.publish(message)
    end
  end
end
