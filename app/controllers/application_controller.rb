class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def redirect_unless_admin
    redirect_to root_path unless logged_in_as_admin?
  end
end
