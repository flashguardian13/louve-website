class PublicationReviewWrapper
  attr_reader :element

  def initialize(element)
    @element = element
  end

  def hide_link
    @element.find_element(css: 'a.hide-review-link')
  end

  def show_link
    @element.find_element(css: 'a.show-review-link')
  end

  def edit_link
    @element.find_element(css: 'a.edit-review-link')
  end

  def delete_link
    @element.find_element(css: 'a.delete-review-link')
  end
end
