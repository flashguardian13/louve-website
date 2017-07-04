class Retailer < ApplicationRecord
  belongs_to :publication
  validates :name, presence: true
  validates :link, presence: true
end
