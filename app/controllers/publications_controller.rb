require 'csv'

class PublicationsController < ContentsController
  def show
    @content = model_class.find(params[:id])
  end

  def import
    redirect_unless_admin
  end

  def import_from_csv
    csv_string = params.permit(:publications_csv)[:publications_csv]
    csv = CSV.parse(csv_string, headers: true)
    hash_table = csv.map { |x| x.to_h }

    Publication.destroy_all

    hash_table.each do |publication_hash|
      Publication.create().update_from_hash(publication_hash)
    end

    redirect_to action: :index, refresh: true
  end

  private

  def content_params
    params.require(:publication).permit(:title, :image, :short_description, :long_description, :sort_index, :is_visible)
  end
end
