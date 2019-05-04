require_relative 'page_wrapper.rb'

class BlogNewPage < PageWrapper
  BASE_URL = "http://localhost:3000/blog_posts/new"

  def initialize(driver)
    super(driver, BASE_URL)
  end

  def title
    @driver.find_element(css: '#blog_post_title')
  end

  def abstract
    @driver.find_element(css: '#blog_post_abstract')
  end

  def content
    @driver.find_element(css: '#blog_post_content')
  end

  def preview
    @driver.find_element(css: '#new_blog_post input[type=submit][value=Preview]')
  end

  def create
    @driver.find_element(css: '#new_blog_post input[type=submit][value=Create]')
  end

  def cancel
    @driver.find_element(css: '#cancel-link')
  end
end
