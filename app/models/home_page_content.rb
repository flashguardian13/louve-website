class HomePageContentValidator < BBCodeValidator
  def validate(home_page_content)
    validate_bbcode(home_page_content, :content)
  end
end

class HomePageContent < ApplicationRecord
  validates_with HomePageContentValidator
end
