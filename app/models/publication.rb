class Publication < ApplicationRecord
  has_many :retailers, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
