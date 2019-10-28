require_relative 'publication_review_wrapper.rb'
require_relative 'publication_retailer_wrapper.rb'

class PublicationWrapper
  attr_reader :element

  def initialize(element)
    @element = element
  end

  def hidden_content
    @element.find_element(css: 'div.read-more-hidden')
  end

  def hide_link
    @element.find_element(css: 'div.publication-admin-links > a.hide-publication-link')
  end

  def show_link
    @element.find_element(css: 'div.publication-admin-links > a.show-publication-link')
  end

  def edit_link
    @element.find_element(css: 'div.publication-admin-links > a.edit-publication-link')
  end

  def delete_link
    @element.find_element(css: 'div.publication-admin-links > a.delete-publication-link')
  end

  def show_more_button
    @element.find_element(css: 'label.read-more-trigger')
  end

  def add_review_link
    @element.find_element(css: 'a.add-review-link')
  end

  def reviews
    @element.find_elements(css: 'div.publication-reviews > div.review').map { |r| PublicationReviewWrapper.new(r) }
  end

  def add_retailer_link
    @element.find_element(css: 'a.add-retailer-link')
  end

  def retailers
    @element.find_elements(css: 'div.publication-retailers > span.retailer').map { |r| PublicationRetailerWrapper.new(r) }
  end
end
