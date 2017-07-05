class PublicationValidator < BBCodeValidator
  def validate(publication)
    validate_bbcode(publication, :short_description)
    validate_bbcode(publication, :long_description)
  end
end

class Publication < ApplicationRecord
  has_many :retailers, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, presence: true
  validates :image, presence: true
  validates :short_description, presence: true
  validates :long_description, presence: true
  validates_with PublicationValidator

  def sort_order(other)
    raise ArgumentError.new("Expected Publication, but received #{other.inspect}!") unless other.is_a?(Publication)
    self_index = self.sort_index || 0
    other_index = other.sort_index || 0
    raise "Classes do not match!" if self_index.class != other_index.class
    return other_index <=> self_index if self_index != other_index
    other.created_at <=> self.created_at
  end
end
