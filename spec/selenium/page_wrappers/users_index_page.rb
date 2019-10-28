require_relative 'page_wrapper.rb'

class UsersIndexPage < PageWrapper
  BASE_URL = "http://localhost:3000/users"

  def initialize(driver)
    super(driver, BASE_URL)
  end

  def alert
    @driver.find_element(css: 'body > div.content > div.alert')
  end

  def new_user_link
    @driver.find_element(css: '#new-user-link')
  end

  def select_user_rows_by_email(email)
    user_rows = @driver.find_elements(css: '#user-list > tbody > tr')
    user_rows.reject! { |row| row['class'].include?('user-headers') }
    user_rows.select { |row| row.find_element(css: 'td.user-email').text == email }
  end

  def select_user_rows_by_type(type)
    user_rows = @driver.find_elements(css: '#user-list > tbody > tr')
    user_rows.reject! { |row| row['class'].include?('user-headers') }
    user_rows.select { |row| row.find_element(css: 'td.user-type').text == type }
  end

  def user_exists?(email)
    select_user_rows_by_email(email).any?
  end

  def user_delete_link(email)
    user_rows = select_user_rows_by_email(email)
    raise "Could not find user with email #{email.inspect}!" if user_rows.empty?
    puts "Warning: more than one user has email #{email.inspect}. Returning first match." if user_rows.length > 1
    user_rows.first.find_element(css: 'a.delete-user-link')
  end
end
