require_relative 'page_wrapper.rb'

class UsersNewPage < PageWrapper
  BASE_URL = "http://localhost:3000/users/new"

  def initialize(driver)
    super(driver, BASE_URL)
  end

  def name
    @driver.find_element(css: '#user_name')
  end

  def email
    @driver.find_element(css: '#user_email')
  end

  def password
    @driver.find_element(css: '#user_password')
  end

  def confirmation
    @driver.find_element(css: '#user_password_confirmation')
  end

  def cancel
    @driver.find_element(css: '#new_user > a#cancel')
  end

  def sign_up
    @driver.find_element(css: '#new_user input[type=submit]')
  end
end
