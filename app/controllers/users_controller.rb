class UsersController < ApplicationController
  def index
    redirect_to root_path unless logged_in? && current_user.is_admin
    @users = User.all
  end

  def show
    redirect_to root_path unless logged_in? && current_user.is_admin
    @user = User.find(params[:id])
  end

  def new
    redirect_to root_path unless logged_in? && current_user.is_admin
    @user = User.new
  end

  def create
    redirect_to root_path unless logged_in? && current_user.is_admin
    @user = User.new(user_params.merge(is_admin: false))
    if @user.save
      flash[:success] = "User created successfully."
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
