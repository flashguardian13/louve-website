class PublicationsController < ContentsController
  private

  def content_params
    params.require(:publication).permit(:title, :image, :short_description, :long_description, :is_visible)
  end
end
