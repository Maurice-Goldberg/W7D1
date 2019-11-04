class UsersController < ApplicationController
    before_action :redirect_if_logged_in

    def create
        @user = User.new(user_params)

        if @user.save
            session[:session_token] = @user.session_token
            flash[:success] = "Welcome, new user! :)"
            redirect_to cats_url
        else
            flash[:error] = "Please enter a username and valid password."
            render :new, status: 422
        end
    end

    def new
        render :new
    end

    private 
    def user_params
        params.require(:user).permit(:user_name, :password)
    end
end