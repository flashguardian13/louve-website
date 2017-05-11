class BlogPostsController < ContentsController
  private

  def content_params
    params.require(:blog_post).permit(:title, :content, :is_visible)
  end
end
