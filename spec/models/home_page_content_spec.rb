require 'rails_helper'

RSpec.describe HomePageContent, type: :model do
  before(:each) do
    @content = HomePageContent.new(content: "There's not much to say. Buy my books!")
  end

  it 'is valid' do
    expect(@content).to be_valid
  end

  it 'allows no content' do
    @content.content = nil
    expect(@content).not_to be_valid

    @content.content = ''
    expect(@content).to be_valid

    @content.content = '                  '
    expect(@content).to be_valid
  end

  it 'cannot contain invalid bbcode' do
    @content.content = "Here's [url='.']a link to this page[/url]."
    expect(@content).not_to be_valid

    @content.content = "[b]These [i]tags are not nested[/b] properly[/i]."
    expect(@content).not_to be_valid

    @content.content = "An open [b]tag with no closure."
    expect(@content).not_to be_valid

    @content.content = "A closing tag with no[/b] opening."
    expect(@content).not_to be_valid
  end
end
