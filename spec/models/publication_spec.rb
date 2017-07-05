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

  it 'can have a sort index' do
    @publication.sort_index = 1
    expect(@publication).to be_valid
    @publication.sort_index = -10
    expect(@publication).to be_valid
    @publication.sort_index = 100
    expect(@publication).to be_valid
    @publication.sort_index = 9999
    expect(@publication).to be_valid
  end

  describe '#sort_order' do
    before(:each) do
      @publication1 = Publication.new(
        title: 'My Blog Post',
        image: "foo.png",
        short_description: "There's not much to say.",
        long_description: "There's not much to say. Buy my books!"
      )
      @publication2 = Publication.new(
        title: 'My Other Blog Post',
        image: "bar.png",
        short_description: "There's even less to say!",
        long_description: "Buy my books already!"
      )
    end

    it 'expects another Publication' do
      ['foo', :bar, 1, true, nil, [], {}, Object.new].each do |bad_arg|
        expect{ @publication1.sort_order(bad_arg) }.to raise_error(ArgumentError)
      end
    end

    context 'when the sort indices are not equal' do
      it 'is based on sort indices' do
        allow(@publication1).to receive(:created_at).and_return(1000)
        allow(@publication2).to receive(:created_at).and_return(1001)
        @publication1.sort_index = 3
        @publication2.sort_index = 2
        expect(@publication1.sort_order(@publication2)).to be < 0
      end
    end

    context 'when the sort indices are equal' do
      it 'is based on creation date' do
        allow(@publication1).to receive(:created_at).and_return(1000)
        allow(@publication2).to receive(:created_at).and_return(1001)
        @publication1.sort_index = 2
        @publication2.sort_index = 2
        expect(@publication1.sort_order(@publication2)).to be > 0
      end
    end

    context 'when both the sort indices and creation dates are equal' do
      it 'returns zero' do
        allow(@publication1).to receive(:created_at).and_return(1)
        allow(@publication2).to receive(:created_at).and_return(1)
        @publication1.sort_index = 2
        @publication2.sort_index = 2
        expect(@publication1.sort_order(@publication2)).to eq(0)
      end
    end
  end
end
