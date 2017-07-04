class BlogPostValidator < BBCodeValidator
  def validate(post)
    validate_bbcode(post, :content)
  end
end

class BlogPost < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates_with BlogPostValidator
end
