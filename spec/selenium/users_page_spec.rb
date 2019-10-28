require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

require_relative 'page_wrappers/users_index_page.rb'
require_relative 'page_wrappers/users_new_page.rb'
require_relative 'page_wrappers/user_show_page.rb'

describe 'Users Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @users_index_page = UsersIndexPage.new(@driver)
    @users_new_page = UsersNewPage.new(@driver)
    @user_show_page = UserShowPage.new(@driver)

    @users_index_page.go
  end

  after(:all) do
    @driver.quit
  end

  it 'is not accessible unless signed in' do
    expect(@driver.current_url).not_to match(@users_index_page.base_url)
  end

  context 'when signed in' do
    before(:all) do
      login_as_admin(@driver)
      @users_index_page.go
    end

    after(:all) do
      logout(@driver)
      @users_index_page.go
    end

    it 'gives the option to create a new user' do
      link = @users_index_page.new_user_link
      expect(link).not_to be_nil
      expect(link).to be_displayed
    end

    context 'when cancelling a new user request' do
      before(:all) do
        wait_for_page_load(@driver) { @users_index_page.new_user_link.click }

        @users_new_page.name.clear
        @users_new_page.name.send_keys('Joe Test')
        @users_new_page.email.clear
        @users_new_page.email.send_keys('joe.test@gmail.com')
        @users_new_page.password.clear
        @users_new_page.password.send_keys('P@ssw0rd1')
        @users_new_page.confirmation.clear
        @users_new_page.confirmation.send_keys('P@ssw0rd1')
        @users_new_page.cancel.click
      end

      it 'goes back to the users page' do
        expect(@driver.current_url).to match(@users_index_page.base_url)
      end

      it 'does not create the user' do
        expect(@users_index_page.user_exists?('joe.test@gmail.com')).to be false
      end
    end

    context 'when creating a new user' do
      before(:all) do
        wait_for_page_load(@driver) { @users_index_page.new_user_link.click }

        @users_new_page.name.clear
        @users_new_page.name.send_keys('Joe Test')
        @users_new_page.email.clear
        @users_new_page.email.send_keys('joe.test@gmail.com')
        @users_new_page.password.clear
        @users_new_page.password.send_keys('P@ssw0rd1')
        @users_new_page.confirmation.clear
        @users_new_page.confirmation.send_keys('P@ssw0rd1')
        @users_new_page.sign_up.click
      end

      it 'displays the new user' do
        expect(@driver.current_url).to match(%r{#{@user_show_page.base_url}\Z})
      end

      it 'creates the user' do
        expect(@user_show_page.alert.text).to eq('User Joe Test created successfully.')
        expect(@user_show_page.user_name.text).to include('Joe Test')
        expect(@user_show_page.user_email.text).to include('joe.test@gmail.com')
      end

      after(:all) do
        @users_index_page.go
      end
    end

    it 'does not allow admins to be deleted' do
      admin_rows = @users_index_page.select_user_rows_by_type('Admin')
      admin_rows.each do |row|
        expect(row.find_elements(css: 'td.delete-user-link')).to be_empty
      end
    end

    context 'when deleting a user' do
      before(:all) do
        skip_confirmation
        @users_index_page.user_delete_link('joe.test@gmail.com').click
      end

      it 'deletes the user' do
        expect(@users_index_page.alert.text).to eq('User Joe Test deleted.')
        expect(@users_index_page.user_exists?('joe.test@gmail.com')).to be false
      end
    end
  end
end
