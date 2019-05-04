require_relative 'page_wrapper.rb'

require_relative 'publication_wrapper.rb'

class PublicationsIndexPage < PageWrapper
  BASE_URL = "http://localhost:3000/publications"

  def initialize(driver)
    super(driver, BASE_URL)
  end

  def new_publication_link
    @driver.find_element(css: '#new-publication-link')
  end

  def publications
    @driver.find_elements(css: 'body > div.content > div.publication-container').map { |p| PublicationWrapper.new(p) }
  end
end
