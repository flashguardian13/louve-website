require 'rails_helper'

RSpec.describe ExternalLink, type: :model do
  before(:each) do
    data = {
      url: 'http://www.potato.com/',
      title: 'Potatoes',
      description: "Potatoes are delicious."
    }
    @link = ExternalLink.new(data)
  end

  it 'is valid' do
    expect(@link).to be_valid
  end

  it 'expects a valid (looking) URL link' do
    valid_urls = %w(
      https://www.example.com
      http://www.example.com
      www.example.com
      example.com
      http://blog.example.com
      http://www.example.com/product
      http://www.example.com/products?id=1&page=2
      http://www.example.com#up
      http://255.255.255.255
      255.255.255.255
      http://www.site.com:8008
      http://www.furaffinity.net/msg/submissions/
      http://www.furaffinity.net/search/
      http://crawl.chaosforge.org/Dragon_slaying
      http://crawl.akrasiac.org:8080/#lobby
      https://mail.google.com/mail/u/0/?tab=mm#inbox
      https://calendar.google.com/calendar/render?tab=mc#main_7
      https://docs.google.com/document/d/1rMdEvGY4OuiykBZHv5nujIRoELFtW77NECUTHwjNjE0/edit
      https://www.amazon.com/links/test/product.asp?foo=bar
      http://128.0.0.1/
      http://stuff/
    )
    valid_urls.each do |url|
      @link.url = url
      expect(@link).to be_valid
    end

    invalid_urls = %w(
      http://invalid.com/perl.cgi?key=
      http://web-site.com/cgi-bin/perl.cgi?key1=value1&key2
      http://www.perfect.com/except-for_these!invalid$characters~@#&*(){}`
      ftp://www.amazon.com/
    )
    invalid_urls.each do |url|
      @link.url = url
      expect(@link).not_to be_valid
    end
  end

  it 'expects title to be present' do
    @link.title = '         '
    expect(@link).not_to be_valid
  end

  it 'expects description to be present' do
    @link.description = '         '
    expect(@link).not_to be_valid
  end
end
