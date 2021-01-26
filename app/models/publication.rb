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

  validates :credits, presence: true
  validates :publisher, presence: true
  validates :publisher_url, presence: true

  validates :publish_date, presence: true

  validates :short_description, presence: true
  validates :long_description, presence: true

  validates_with PublicationValidator

  def sort_order(other)
    raise ArgumentError.new("Expected Publication, but received #{other.inspect}!") unless other.is_a?(Publication)
    self_index = self.sort_index || 0
    other_index = other.sort_index || 0
    raise "Classes do not match!" if self_index.class != other_index.class
    return other_index <=> self_index if self_index != other_index
    other.publish_date <=> self.publish_date
  end

  RETAILER_LINK_KEYS = [
    "Green Ronin Store Link",
    "Drive Thru RPG Link",
    "Amazon Link",
    "Good Reads Link",
    "Frog God Games Link",
    "Barnes and Noble Link",
    "Best Buy Link",
    "Booktopia Link",
    "Immanion Press Link",
    "Abe Books Link"
  ].freeze

  SPREADSHEET_KEYS = (RETAILER_LINK_KEYS + [
    "Sort Value",
    "Publication Title",
    "Credit and Contributions",
    "Publication Date",
    "Publisher",
    "Publisher Link",
    "Image Link",
    "Summary",
    "Additional Details"
  ]).freeze

  def update_from_hash(hash)
    missing_keys = SPREADSHEET_KEYS - hash.keys
    raise(
      ArgumentError,
      "Missing keys: #{missing_keys.inspect}"
    ) if missing_keys.any?

    extra_keys = hash.keys - SPREADSHEET_KEYS
    raise(
      ArgumentError,
      "Extra keys: #{extra_keys.inspect}"
    ) if extra_keys.any?

    self.sort_index = hash['Sort Value']
    self.title = hash['Publication Title']
    self.image = hash['Image Link']
    self.credits = hash['Credit and Contributions']
    self.publisher = hash['Publisher']
    self.publisher_url = hash['Publisher Link']
    self.publish_date = Date.parse(hash['Publication Date'])
    self.short_description = hash['Summary']
    self.long_description = hash['Additional Details']
    self.is_visible = true

    save!

    self.retailers.destroy_all
    RETAILER_LINK_KEYS.each do |retailer_key|
      next unless hash[retailer_key]
      retailer = self.retailers.create(name: retailer_key.gsub(/ Link$/, ''), link: hash[retailer_key])
      retailer.is_visible = true
      retailer.save!
    end
  end
end
