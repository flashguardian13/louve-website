require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'Contacts Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @base_url = "http://localhost:3000/contact"
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end

  after(:all) do
    @driver.quit
  end

  it 'contains the expected links' do
    links = @driver.find_elements(css: 'body > div.content > div > div > a')

    link_texts = links.map { |link| link.text }
    expected = [
      'Rhiannon on Facebook',
      'Rhiannon on Google Plus',
      'Rhiannon on Twitter'
    ]
    expect(link_texts).to match_array(expected)

    link_urls = links.map { |link| link['href'] }
    expected = [
      'https://www.facebook.com/rhiannon.louve.9',
      'https://plus.google.com/111174430831744560002',
      'https://twitter.com/RhiannonLouve'
    ]
    expect(link_urls).to match_array(expected)
  end
end
