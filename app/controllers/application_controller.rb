class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def redirect_unless_admin
    redirect_to root_path unless logged_in? && current_user.is_admin
  end
end
