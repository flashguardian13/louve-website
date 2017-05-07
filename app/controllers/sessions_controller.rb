class SessionsController < ApplicationController
  def new
    session[:return_to] ||= request.referer
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      log_in(user)
      redirect_to(session.delete(:return_to) || root_path)
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_back(fallback_location: root_path)
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
