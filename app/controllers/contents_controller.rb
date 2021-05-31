class ContentsController < ApplicationController
  before_action :redirect_unless_admin, except: [:index, :show]

  def index
    @contents = model_class.all
  end

  def new
    @content = model_class.new
  end

  def create
    @content = model_class.new(content_params)
    if params[:commit] != 'Preview' && @content.save
      redirect_to action: :index, refresh: true
    else
      render 'new'
    end
  end

  def edit
    @content = model_class.find(params[:id])
  end

  def update
    @content = model_class.find(params[:id])
    if params[:commit] == 'Preview'
      @content.assign_attributes(content_params)
      render 'edit'
    elsif @content.update_attributes(content_params)
      redirect_to action: :index, refresh: true
    else
      render 'edit'
    end
  end

  def destroy
    content = model_class.find(params[:id])
    content.destroy

    @contents = model_class.all
    render 'index'
  end

  private

  def model_class
    controller_name.classify.constantize
  end
end
