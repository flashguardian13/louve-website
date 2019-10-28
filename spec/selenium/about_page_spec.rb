require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'About Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @base_url = "http://localhost:3000/about"
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end

  after(:all) do
    @driver.quit
  end

  it 'contains the expected text' do
    elements = @driver.find_elements(css: 'body > div.content span.about-section-intro')
    expect(elements.length).to eq(4)

    intro_texts = elements.map { |e| e.text }
    expected = [
      "Rhiannon Louve as author:",
      "Rhiannon Louve as dreamer:",
      "Rhiannon Louve as spiritual futurist:",
      "Rhiannon Louve's life history at a glance:"
    ]
    expect(intro_texts).to match_array(expected)
  end
end
