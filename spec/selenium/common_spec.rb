require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'Common Elements' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @base_url = "http://localhost:3000/"
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end

  after(:all) do
    @driver.quit
  end

  it 'has six navigation buttons at the top and bottom' do
    ['header > div.navbar > nav > ul a', 'footer > div.navbar > nav > ul a'].each do |selector|
      nav_links = @driver.find_elements(css: selector)
      expect(nav_links.length).to eq(6)

      link_texts = nav_links.map { |b| b.text }
      expected = %w(Home About Publications Blogs Links Contact)
      expect(link_texts).to match_array(expected)

      link_paths = nav_links.map { |b| b['href'] }
      expected = [
        'http://localhost:3000/',
        'http://localhost:3000/about',
        'http://localhost:3000/publications',
        'http://localhost:3000/blogs',
        'http://localhost:3000/links',
        'http://localhost:3000/contact'
      ]
      expect(link_paths).to match_array(expected)
    end
  end

  it 'has four social media buttons at the top and bottom' do
    expect(@driver.find_elements(css: 'body > div.center > div > div.twitter-container')).not_to be_empty
    expect(@driver.find_elements(css: 'body > div.center > div > a')).not_to be_empty
    expect(@driver.find_elements(css: 'body > div.center > div > div.fb-like-container')).not_to be_empty

    expect(@driver.find_elements(css: 'body > div.content > div.post-container > div.center > div > div.twitter-container')).not_to be_empty
    expect(@driver.find_elements(css: 'body > div.content > div.post-container > div.center > div > a')).not_to be_empty
    expect(@driver.find_elements(css: 'body > div.content > div.post-container > div.center > div > div.fb-like-container')).not_to be_empty
  end

  it 'has working nav buttons' do
    [
      ['a#home-button', 'Home | Rhiannon Louve', 'http://localhost:3000/'],
      ['a#about-button', 'About | Rhiannon Louve', 'http://localhost:3000/about'],
      ['a#publications-button', 'Publications | Rhiannon Louve', 'http://localhost:3000/publications'],
      ['a#blogs-button', 'Blog | Rhiannon Louve', 'http://localhost:3000/blogs'],
      ['a#links-button', 'Links | Rhiannon Louve', 'http://localhost:3000/links'],
      ['a#contact-button', 'Contacts | Rhiannon Louve', 'http://localhost:3000/contact'],
    ].shuffle.each do |selector, title, url|
      wait_for_page_load(@driver) { @driver.find_element(css: selector).click }
      expect(@driver.title).to eq(title)
      expect(@driver.current_url).to eq(url)
    end
  end

  context 'when signed in' do
    before(:all) do
      login_as_admin(@driver)
      wait_for_page_load(@driver) { @driver.navigate.to @base_url }
    end

    after(:all) do
      logout(@driver)
      wait_for_page_load(@driver) { @driver.navigate.to @base_url }
    end

    it 'displays the username' do
      element = @driver.find_element(css: 'header > div#login-info')
      expect(element.text).to include('signed in')
      expect(element.text).to include('admin')
    end

    it 'displays a users button' do
      nav_links = @driver.find_elements(css: 'header > div.navbar > nav > ul a')
      expect(nav_links.length).to eq(7)

      link_texts = nav_links.map { |b| b.text }
      expected = %w(Home About Publications Blogs Links Contact Users)
      expect(link_texts).to match_array(expected)

      link_paths = nav_links.map { |b| b['href'] }
      expected = [
        'http://localhost:3000/',
        'http://localhost:3000/about',
        'http://localhost:3000/publications',
        'http://localhost:3000/blogs',
        'http://localhost:3000/links',
        'http://localhost:3000/contact',
        'http://localhost:3000/users'
      ]
      expect(link_paths).to match_array(expected)
    end
  end
end
