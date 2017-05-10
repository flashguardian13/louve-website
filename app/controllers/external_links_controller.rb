class ExternalLinksController < ApplicationController
  before_action :redirect_unless_admin, except: [:index]

  def index
    @links = ExternalLink.all
  end

  def new
    @link = ExternalLink.new
  end

  def create
    @link = ExternalLink.new(link_params)
    if params[:commit] != 'Preview' && @link.save
      redirect_to action: :index, refresh: true
    else
      render 'new'
    end
  end

  def edit
    @link = ExternalLink.find(params[:id])
  end

  def update
    @link = ExternalLink.find(params[:id])
    if params[:commit] == 'Preview'
      @link.assign_attributes(link_params)
      render 'edit'
    elsif @link.update_attributes(link_params)
      redirect_to action: :index, refresh: true
    else
      render 'edit'
    end
  end

  def destroy
    link = ExternalLink.find(params[:id])
    link.destroy

    @links = ExternalLink.all
    render 'index'
  end

  private

  def link_params
    params.require(:external_link).permit(:url, :title, :description, :is_visible)
  end
end
