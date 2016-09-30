 class SessionsController < ApplicationController
    def new
    end

    def create
      @user = User.find_by(username: params[:session][:username])
      if @user && @user.authenticate(params[:session][:password])
        session[:user_id] = @user.id
        puts "**** session[userid] is #{session[:user_id]} ****"
        redirect_to '/'
      else
        redirect_to '/login'
        flash[:notice] = "Error: User/password combination unknown"
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to '/login'
    end
  end
