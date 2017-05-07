class BlogPostsController < ApplicationController
  before_action :redirect_unless_admin, except: [:index]

  def index
    @posts = BlogPost.all
  end

  def new
    @post = BlogPost.new
  end

  def create
    @post = BlogPost.new(post_params)
    if params[:commit] != 'Preview' && @post.save
      redirect_to action: :index, refresh: true
    else
      render 'new'
    end
  end

  def edit
    @post = BlogPost.find(params[:id])
  end

  def update
    @post = BlogPost.find(params[:id])
    if params[:commit] == 'Preview'
      @post.assign_attributes(post_params)
      render 'edit'
    elsif @post.update_attributes(post_params)
      redirect_to action: :index, refresh: true
    else
      render 'edit'
    end
  end

  def destroy
    post = BlogPost.find(params[:id])
    post.destroy

    @posts = BlogPost.all
    render 'index'
  end

  private

  def post_params
    params.require(:blog_post).permit(:title, :content, :is_visible)
  end
end
