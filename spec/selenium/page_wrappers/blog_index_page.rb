require_relative 'page_wrapper.rb'

class BlogIndexPage < PageWrapper
  BASE_URL = "http://localhost:3000/blogs"

  def initialize(driver)
    super(driver, BASE_URL)
  end

  def new_post_link
    @driver.find_element(css: '#new-post-link')
  end

  def posts
    @driver.find_elements(css: 'body > div.content > div.post-container')
  end

  def find_post_index_by_title(title)
    posts.each_index { |i| return i if blog_visit_link(i).text == title }
    nil
  end

  def blog_visit_link(index)
    posts[index].find_element(css: 'a.visit-link')
  end

  def blog_hide_link(index)
    posts[index].find_element(css: 'a.hide-link')
  end

  def blog_show_link(index)
    posts[index].find_element(css: 'a.show-link')
  end

  def blog_edit_link(index)
    posts[index].find_element(css: 'a.edit-link')
  end

  def blog_delete_link(index)
    posts[index].find_element(css: 'a.delete-link')
  end
end
