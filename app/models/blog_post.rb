class BlogPostValidator < ActiveModel::Validator
  def validate(post)
    if post.content.is_a?(String)
      errors = post.content.bbcode_check_validity
      if errors.is_a?(Array) && !errors.empty?
        post.errors[:content].concat(errors)
      end
    else
      post.errors[:content] << 'Content cannot be anything other than text.'
    end
  end
end

class BlogPost < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates_with BlogPostValidator
end
