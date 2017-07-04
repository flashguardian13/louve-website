require 'rails_helper'

RSpec.describe Review, type: :model do
  before(:each) do
    publication = Publication.new
    @review = publication.reviews.build(
      quote: "Oh my god this is the greatest book I've ever read in my life!",
      attribution: "That One Critic"
    )
  end

  it 'is valid' do
    expect(@review).to be_valid
  end

  it 'requires a quote' do
    @review.quote = nil
    expect(@review).not_to be_valid

    @review.quote = ''
    expect(@review).not_to be_valid

    @review.quote = '                  '
    expect(@review).not_to be_valid
  end

  it 'requires a attribution' do
    @review.attribution = nil
    expect(@review).not_to be_valid

    @review.attribution = ''
    expect(@review).not_to be_valid

    @review.attribution = '                  '
    expect(@review).not_to be_valid
  end

  it 'can be hidden or visible' do
    @review.is_visible = true
    expect(@review).to be_valid

    @review.is_visible = false
    expect(@review).to be_valid
  end
end
