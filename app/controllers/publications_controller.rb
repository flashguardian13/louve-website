class PublicationsController < ContentsController
  def show
    @content = model_class.find(params[:id])
  end

  private

  def content_params
    params.require(:publication).permit(:title, :image, :short_description, :long_description, :is_visible)
  end
end
