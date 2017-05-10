class ExternalLink < ApplicationRecord
  validates :url, presence: true,
                  format: { with: %r{\A(?:http(s)?:\/\/)?[\w\d]+(?:\.[\w\d]+)*(?::\d+)?(?:\/[\w\d\.]+)*\/?(?:\?[\w\d]+=[\w\d]+(?:&[\w\d]+=[\w\d]+)*)?(?:#[\w\d]+)?\Z}i }
  validates :title,  presence: true
  validates :description,  presence: true
end
