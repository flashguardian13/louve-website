class BlogPostsController < ApplicationController
  before_action :redirect_unless_admin

  def index
    @posts = BlogPost.all
  end

  def new
    @post = BlogPost.new
  end

  def create
    @post = BlogPost.new(post_params)
    if @post.save
      @posts = BlogPost.all
      render 'index'
    else
      render 'new'
    end
  end

  def edit
    @post = BlogPost.find(params[:id])
  end

  def update
    @post = BlogPost.find(params[:id])
    if @post.update_attributes(post_params)
      redirect_to 'index'
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
    params.require(:blog_post).permit(:title, :content)
  end
end
