require_relative 'page_wrapper.rb'

class ReviewNewPage < PageWrapper
  BASE_URL = "http://localhost:3000/publications/\\d+/reviews/new"

  def initialize(driver)
    super(driver, BASE_URL)
  end

  def quote
    @driver.find_element(css: '#review_quote')
  end

  def attribution
    @driver.find_element(css: '#review_attribution')
  end

  def preview
    @driver.find_element(css: '#new_review input[type=submit][value=Preview]')
  end

  def add
    @driver.find_element(css: '#new_review input[type=submit][value=Add]')
  end

  def cancel
    @driver.find_element(css: '#cancel-link')
  end
end
