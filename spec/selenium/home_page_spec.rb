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

  it 'has welcome text' do
    e = @driver.find_element(css: '#welcome')
    expect(e.text).to include('Rhiannon Louve')
    expect(e.text).to include('Welcome!')
  end

  it 'has custom content' do
    e = @driver.find_element(css: 'body > div.content > div.post-content')
    expect(e.text).to include('something completely different')
  end

  it 'shows the first blog post' do
    posts = @driver.find_elements(css: 'body > div.content > div.post-container')
    expect(posts.length).to eq(1)
  end

  it 'shows a summary of the first publication' do
    publications = @driver.find_elements(css: 'body > div.content > div.publication-container')
    expect(publications.length).to eq(1)
  end

  it 'shows a news blurb' do
    news = @driver.find_element(css: 'body > div.content > div#news-and-events > h2')
    expect(news.text).to include('News and Events')
  end
end
