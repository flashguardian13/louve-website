class ExternalLinksController < ContentsController
  private

  def content_params
    params.require(:external_link).permit(:url, :title, :description, :is_visible)
  end
end
