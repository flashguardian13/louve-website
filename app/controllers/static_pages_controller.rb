class StaticPagesController < ApplicationController
  def home
    @publication = Publication.all.select { |p| p.is_visible }.first
    @blog_post = BlogPost.all.select { |b| b.is_visible }.first
  end

  def about
  end

  def contact
  end

  def links
  end

  def publications
  end
end
