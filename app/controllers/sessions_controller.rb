class SessionsController < ApplicationController
  skip_before_action :authorize!, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:x] = user.id
      redirect_to agents_path
    else
      redirect_to new_session_path
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end
end
