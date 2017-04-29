module ApplicationHelper
  def full_title(page_title = '')
    parts = ['Rhiannon Louve']
    parts.unshift(page_title) unless page_title.empty?
    parts.join(' | ')
  end
end
