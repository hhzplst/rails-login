class SessionsController < ApplicationController
  def login
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = User.where(username: params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
        if authorized_user
          session[:user_id] = authorized_user.id
          session[:username] = authorized_user.username
          redirect_to home_path, notice: "You are now logged in!"
        end
      # else
      #   render :login, notice: ""
      end
    # render :login
    end
   # else
    flash.now[:notice] = "you gotta have both username and password typed in!!"
    render :login
  end

  def signup
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      session[:username] = @user.username
      redirect_to home_path, notice: "You are now logged in!"
    else
      render :signup
    end
  end

  def home
    if session[:user_id]
      @current_user = session[:username]  
    else
      redirect_to login_path, notice: "You have to sign in first!!"
    end
  end

  def logout
    session.clear
    redirect_to login_path
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
