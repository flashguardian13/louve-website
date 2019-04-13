require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'Publications Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @base_url = "http://localhost:3000/publications"
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end

  after(:all) do
    @driver.quit
  end

  it 'contains one or more publications' do
    publications = @driver.find_elements(css: 'body > div.content > div.publication-container')
    expect(publications.length).to be > 0
  end

  context 'when show more is clicked' do
    it 'displays more information' do
      publications = @driver.find_elements(css: 'body > div.content > div.publication-container')
      publication = publications.first

      read_more = publication.find_element(css: 'div.read-more-hidden')
      expect(read_more).not_to be_displayed

      wait_for_page_load(@driver) { publication.find_element(css: 'label').click }
      expect(read_more).to be_displayed
    end
  end
end
