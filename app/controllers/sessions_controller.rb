class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(username: user_params[:username])
    if user && user.authenticate(user_params[:password])
      session[:x] = user.id
      redirect_to agents_path
    end
    redirect_to new_session_path
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end
end
