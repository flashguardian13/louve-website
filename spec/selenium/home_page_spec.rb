require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'Home Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @driver.navigate.to "http://localhost:3000/"
    attach_turbolinks_listeners(@driver)
  end

  after(:all) do
    @driver.quit
  end

  it 'has the expected title' do
  end

  it 'has welcome text' do
  end

  it 'shows the first blog post' do
  end

  it 'shows a summary of the first publication' do
  end

  it 'shows a news blurb' do
  end

  context 'when show more is clicked' do
    it 'shows full publication information' do
    end
  end
end
