require_relative 'page_wrapper.rb'

class UserShowPage < PageWrapper
  BASE_URL = "http://localhost:3000/users/\\d+"

  def initialize(driver)
    super(driver, BASE_URL)
  end

  def alert
    @driver.find_element(css: 'body > div.content > div.alert')
  end

  def user_name
    @driver.find_element(css: '#user-name')
  end

  def user_email
    @driver.find_element(css: '#user-email')
  end

  def edit_user_link
    @driver.find_element(css: '#link-edit-user')
  end

  def back_link
    @driver.find_element(css: '#link-back')
  end
end
