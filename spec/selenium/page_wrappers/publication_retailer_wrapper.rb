class PublicationRetailerWrapper
  attr_reader :element

  def initialize(element)
    @element = element
  end

  def hide_link
    @element.find_element(css: 'a.hide-retailer-link')
  end

  def show_link
    @element.find_element(css: 'a.show-retailer-link')
  end

  def edit_link
    @element.find_element(css: 'a.edit-retailer-link')
  end

  def delete_link
    @element.find_element(css: 'a.delete-retailer-link')
  end
end
