class SessionsController < ApplicationController
    before_action :redirect_if_logged_in

    def new
        render :new
    end

    def create
        user = User.find_by_credentials(params[:user_name], params[:password])
        if user
            login_user!(user)
            flash[:success] = "Welcome back, dear user! :)"
            redirect_to cats_url
        else
            flash[:error] = "Invalid username/password combination"
            render :new, status: 401
        end
    end

    def destroy
        current_user.reset_session_token!
        session[:session_token] = nil
        flash[:success] = "You are now logged out!"
        
        redirect_to cats_url
    end
end