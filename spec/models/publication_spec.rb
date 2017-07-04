require 'rails_helper'

RSpec.describe Publication, type: :model do
  before(:each) do
    @publication = Publication.new(
      title: 'My Blog Post',
      image: "foo.png",
      short_description: "There's not much to say.",
      long_description: "There's not much to say. Buy my books!"
    )
  end

  it 'is valid' do
    expect(@publication).to be_valid
  end

  it 'requires a title' do
    @publication.title = nil
    expect(@publication).not_to be_valid

    @publication.title = ''
    expect(@publication).not_to be_valid

    @publication.title = '                  '
    expect(@publication).not_to be_valid
  end

  it 'requires an image' do
    @publication.image = nil
    expect(@publication).not_to be_valid

    @publication.image = ''
    expect(@publication).not_to be_valid

    @publication.image = '                  '
    expect(@publication).not_to be_valid
  end

  describe '#short_description' do
    it 'must be present' do
      @publication.short_description = nil
      expect(@publication).not_to be_valid

      @publication.short_description = ''
      expect(@publication).not_to be_valid

      @publication.short_description = '                  '
      expect(@publication).not_to be_valid
    end

    it 'cannot contain invalid bbcode' do
      @publication.short_description = "Here's [url='.']a link to this page[/url]."
      expect(@publication).not_to be_valid

      @publication.short_description = "[b]These [i]tags are not nested[/b] properly[/i]."
      expect(@publication).not_to be_valid

      @publication.short_description = "An open [b]tag with no closure."
      expect(@publication).not_to be_valid

      @publication.short_description = "A closing tag with no[/b] opening."
      expect(@publication).not_to be_valid
    end
  end

  describe '#long_description' do
    it 'must be present' do
      @publication.long_description = nil
      expect(@publication).not_to be_valid

      @publication.long_description = ''
      expect(@publication).not_to be_valid

      @publication.long_description = '                  '
      expect(@publication).not_to be_valid
    end

    it 'cannot contain invalid bbcode' do
      @publication.long_description = "Here's [url='.']a link to this page[/url]."
      expect(@publication).not_to be_valid

      @publication.long_description = "[b]These [i]tags are not nested[/b] properly[/i]."
      expect(@publication).not_to be_valid

      @publication.long_description = "An open [b]tag with no closure."
      expect(@publication).not_to be_valid

      @publication.long_description = "A closing tag with no[/b] opening."
      expect(@publication).not_to be_valid
    end
  end

  it 'can be hidden or visible' do
    @publication.is_visible = true
    expect(@publication).to be_valid

    @publication.is_visible = false
    expect(@publication).to be_valid
  end

  it 'can have one or more retailers' do
    publication = Publication.new(
      title: 'My Blog Post',
      image: "foo.png",
      short_description: "There's not much to say.",
      long_description: "There's not much to say. Buy my books!"
    )
    expect(publication.retailers.length).to eq(0)
    3.times { publication.retailers.build }
    expect(publication.retailers.length).to eq(3)
  end

  it 'can have one or more reviews' do
    publication = Publication.new(
      title: 'My Blog Post',
      image: "foo.png",
      short_description: "There's not much to say.",
      long_description: "There's not much to say. Buy my books!"
    )
    expect(publication.reviews.length).to eq(0)
    3.times { publication.reviews.build }
    expect(publication.reviews.length).to eq(3)
  end
end
