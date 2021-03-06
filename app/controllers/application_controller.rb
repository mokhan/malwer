class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize!

  protected

  def publish(message)
    Publisher.publish(message)
  end

  private

  def authorize!
    redirect_to new_session_path if current_user.nil?
  end

  def current_user
    return nil if session[:x].blank?
    @current_user ||= User.find(session[:x])
  end
end
