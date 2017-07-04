require 'rails_helper'

RSpec.describe Retailer, type: :model do
  before(:each) do
    publication = Publication.new
    @retailer = publication.retailers.build(
      name: 'My Blog Post',
      link: "foo.png"
    )
  end

  it 'is valid' do
    expect(@retailer).to be_valid
  end

  it 'requires a name' do
    @retailer.name = nil
    expect(@retailer).not_to be_valid

    @retailer.name = ''
    expect(@retailer).not_to be_valid

    @retailer.name = '                  '
    expect(@retailer).not_to be_valid
  end

  it 'requires a link' do
    @retailer.link = nil
    expect(@retailer).not_to be_valid

    @retailer.link = ''
    expect(@retailer).not_to be_valid

    @retailer.link = '                  '
    expect(@retailer).not_to be_valid
  end

  it 'can be hidden or visible' do
    @retailer.is_visible = true
    expect(@retailer).to be_valid

    @retailer.is_visible = false
    expect(@retailer).to be_valid
  end
end
