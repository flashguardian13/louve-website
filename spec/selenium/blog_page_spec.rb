require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'Blog Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @base_url = "http://localhost:3000/blogs"
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end

  after(:all) do
    @driver.quit
  end

  it 'contains one or more blog posts' do
    posts = @driver.find_elements(css: 'body > div.content > div.post-container')
    expect(posts.length).to be > 0
  end
end
