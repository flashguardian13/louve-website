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
end
