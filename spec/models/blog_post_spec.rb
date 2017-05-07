require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  before(:each) do
    @blog_post = BlogPost.new(title: 'My Blog Post', content: "There's not much to say. Buy my books!")
  end

  it 'is valid' do
    expect(@blog_post).to be_valid
  end

  it 'requires a title' do
    @blog_post.title = nil
    expect(@blog_post).not_to be_valid

    @blog_post.title = ''
    expect(@blog_post).not_to be_valid

    @blog_post.title = '                  '
    expect(@blog_post).not_to be_valid
  end

  it 'requires some content' do
    @blog_post.content = nil
    expect(@blog_post).not_to be_valid

    @blog_post.content = ''
    expect(@blog_post).not_to be_valid

    @blog_post.content = '                  '
    expect(@blog_post).not_to be_valid
  end

  it 'cannot contain invalid bbcode' do
    @blog_post.content = "Here's [url='.']a link to this page[/url]."
    expect(@blog_post).not_to be_valid

    @blog_post.content = "[b]These [i]tags are not nested[/b] properly[/i]."
    expect(@blog_post).not_to be_valid

    @blog_post.content = "An open [b]tag with no closure."
    expect(@blog_post).not_to be_valid

    @blog_post.content = "A closing tag with no[/b] opening."
    expect(@blog_post).not_to be_valid
  end

  it 'can be hidden or visible' do
    @blog_post.is_visible = true
    expect(@blog_post).to be_valid

    @blog_post.is_visible = false
    expect(@blog_post).to be_valid
  end
end
