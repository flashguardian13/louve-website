class RetailersController < ApplicationController
  before_action :redirect_unless_admin, except: [:index]

  def index
    redirect_to "publications/#{params[:publication_id]}"
  end

  def new
    @publication = Publication.find(params[:publication_id])
    @content = @publication.retailers.build
  end

  def create
    @publication = Publication.find(params[:publication_id])
    @content = @publication.retailers.build(content_params)
    if params[:commit] != 'Preview' && @content.save
      redirect_to "/publications/#{params[:publication_id]}", refresh: true
    else
      render 'new'
    end
  end

  def edit
    @publication = Publication.find(params[:publication_id])
    @content = @publication.retailers.find(params[:id])
  end

  def update
    @publication = Publication.find(params[:publication_id])
    @content = @publication.retailers.find(params[:id])
    if params[:commit] == 'Preview'
      @content.assign_attributes(content_params)
      render 'edit'
    elsif @content.update_attributes(content_params)
      redirect_to "/publications/#{params[:publication_id]}", refresh: true
    else
      render 'edit'
    end
  end

  def destroy
    @publication = Publication.find(params[:publication_id])
    content = @publication.retailers.find(params[:id])
    content.destroy

    redirect_to "/publications/#{params[:publication_id]}", refresh: true
  end

  private

  def content_params
    params.require(:retailer).permit(:name, :link, :is_visible)
  end
end
