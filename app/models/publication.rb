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
end
