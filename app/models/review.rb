class Review < ApplicationRecord
  belongs_to :publication
  validates :quote, presence: true
  validates :attribution, presence: true
end
