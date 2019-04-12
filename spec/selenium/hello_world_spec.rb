require "selenium-webdriver"

describe 'HelloWorld' do
  it 'works' do
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to "http://localhost:3000/"

    expect(driver.title).to eq('Home | Rhiannon Louve')

    element = driver.find_element(css: 'body')
    expect(element.text).to include('Author, Dreamer, Spiritual Futurist')

    driver.quit
  end
end
