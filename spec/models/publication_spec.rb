require 'rails_helper'

RSpec.describe Publication, type: :model do
  before(:each) do
    @publication = Publication.new(
      title: 'My Publication',
      image: "foo.png",
      credits: 'Author',
      publisher: 'Moon Shot Studios',
      publisher_url: 'https://www.moonshotstudios.com',
      publish_date: Date.parse('2020/05/25'),
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

  it 'requires credits' do
    @publication.credits = nil
    expect(@publication).not_to be_valid

    @publication.credits = ''
    expect(@publication).not_to be_valid

    @publication.credits = '                  '
    expect(@publication).not_to be_valid
  end

  it 'requires publisher' do
    @publication.publisher = nil
    expect(@publication).not_to be_valid

    @publication.publisher = ''
    expect(@publication).not_to be_valid

    @publication.publisher = '                  '
    expect(@publication).not_to be_valid
  end

  it 'requires publisher_url' do
    @publication.publisher_url = nil
    expect(@publication).not_to be_valid

    @publication.publisher_url = ''
    expect(@publication).not_to be_valid

    @publication.publisher_url = '                  '
    expect(@publication).not_to be_valid
  end

  it 'requires publish_date' do
    @publication.publish_date = nil
    expect(@publication).not_to be_valid

    @publication.publish_date = ''
    expect(@publication).not_to be_valid

    @publication.publish_date = '                  '
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
      it 'is based on publish date' do
        allow(@publication1).to receive(:publish_date).and_return(1000)
        allow(@publication2).to receive(:publish_date).and_return(1001)
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

  describe '#update_from_hash' do
    let(:dummy_hash) do
      {
        "Sort Value" =>               4,
        "Publication Title" =>        "Grand Reme",
        "Credit and Contributions" => 'Editor',
        "Publication Date" =>         "September 25, 2020",
        "Publisher" =>                "Frog God Games",
        "Publisher Link" =>           "https://www.froggodgames.com/",
        "Image Link" =>               "https://dtrpg-public-files.amazonaws.com/images/309493.jpg",
        "Summary" =>                  "This is a summary.",
        "Additional Details" =>       "A summary is a shorter blurb of text meant to convey the basic meaning of a larger body.",
        "Green Ronin Store Link" =>   'https://www.greenronin.com/product/12345/grand-reme',
        "Drive Thru RPG Link" =>      "https://www.drivethrurpg.com/product/309493/Grand-Reme",
        "Amazon Link" =>              "https://www.amazon.com/Grand-Reme-Matt-Finch/dp/1622838459",
        "Good Reads Link" =>          'https://www.goodreads.com/product/12345/grand-reme',
        "Frog God Games Link" =>      "https://www.froggodgames.com/product/grand-reme/",
        "Barnes and Noble Link" =>    'https://www.barnes-noble.com/product/12345/grand-reme',
        "Best Buy Link" =>            'https://www.bestbuy.com/product/12345/grand-reme',
        "Booktopia Link" =>           'https://www.booktopia.com/product/12345/grand-reme',
        "Immanion Press Link" =>      'https://www.immanion.com/product/12345/grand-reme',
        "Abe Books Link" =>           'https://www.abe-books.com/product/12345/grand-reme'
      }
    end

    it 'sets all values based on the given hash' do
      @publication.update_from_hash(dummy_hash)
      expect(@publication.sort_index).to eq(4)
      expect(@publication.title).to eq('Grand Reme')
      expect(@publication.image).to eq("https://dtrpg-public-files.amazonaws.com/images/309493.jpg")
      expect(@publication.credits).to eq('Editor')
      expect(@publication.publisher).to eq('Frog God Games')
      expect(@publication.publisher_url).to eq('https://www.froggodgames.com/')
      expect(@publication.publish_date).to eq(Date.parse("September 25, 2020"))
      expect(@publication.short_description).to eq('This is a summary.')
      expect(@publication.long_description).to eq('A summary is a shorter blurb of text meant to convey the basic meaning of a larger body.')

      retailers = {}
      @publication.retailers.each do |retailer|
        retailers[retailer.name] = retailer.link
      end
      expect(retailers['Green Ronin Store']).to match(/www.greenronin.com/)
      expect(retailers['Drive Thru RPG']).to match(/www.drivethrurpg.com/)
      expect(retailers['Amazon']).to match(/www.amazon.com/)
      expect(retailers['Good Reads']).to match(/www.goodreads.com/)
      expect(retailers['Frog God Games']).to match(/www.froggodgames.com/)
      expect(retailers['Barnes and Noble']).to match(/www.barnes-noble.com/)
      expect(retailers['Best Buy']).to match(/www.bestbuy.com/)
      expect(retailers['Booktopia']).to match(/www.booktopia.com/)
      expect(retailers['Immanion Press']).to match(/www.immanion.com/)
      expect(retailers['Abe Books']).to match(/www.abe-books.com/)
    end

    it 'complains about unknown keys' do
      expect { @publication.update_from_hash(dummy_hash.merge('foo' => 'bar')) }.to raise_error(ArgumentError)
    end

    it 'complains about missing keys' do
      expect { @publication.update_from_hash('foo' => 'bar') }.to raise_error(ArgumentError)
    end

    it 'sets the publication and referenced objects to be visible' do
      @publication.update_from_hash(dummy_hash)
      expect(@publication.is_visible).to eq(true)
      @publication.retailers.each do |retailer|
        expect(retailer.is_visible).to eq(true)
      end
    end
  end
end
