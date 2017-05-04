class UsersController < ApplicationController
  before_action :redirect_unless_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(is_admin: false))
    if @user.save
      flash[:success] = "User #{@user.name} created successfully."
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.authenticate(params[:user][:password])
      if @user.update_attributes(user_params)
        flash[:success] = "User #{@user.name} updated successfully."
        redirect_to @user
      else
        render 'edit'
      end
    else
      @user.errors.add(:password, "was incorrect.")
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    log_out if current_user == user
    user.destroy
    flash.now[:success] = "User #{user.name} deleted."

    @users = User.all
    render 'index'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
