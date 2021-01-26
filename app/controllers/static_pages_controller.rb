class StaticPagesController < ApplicationController
  before_action :redirect_unless_admin, except: [:home, :about, :contact]

  def home
    @publication = Publication.all.sort { |a, b| a.sort_order(b) }.select { |p| p.is_visible }.first
    @blog_post = BlogPost.all.select { |b| b.is_visible }.last
    @custom_content = HomePageContent.all.last
    @facebook_metadata = {
      # 'fb:app_id' => 'APP_ID_HERE', <-- Find this value in your App Dashboard. Populate based on environment.
      'og:url' => root_url,
      'og:type' => 'website',
      'og:title' => 'Rhiannon Louve',
      'og:description' => 'Rhiannon Louve is an author, philosopher, teller of tales, spinner of epics, creator of worlds, and radical hippie weirdo.',
      'og:image' => '/images/rhiannon_louve_logo_facebook.jpg'
    }
  end

  def edit_home_content
    @custom_content = HomePageContent.all.last || HomePageContent.new
  end

  def update_home_content
    @custom_content = HomePageContent.all.last || HomePageContent.new(home_content_params)
    if params[:commit] == 'Preview'
      @custom_content.assign_attributes(home_content_params)
      render 'edit_home_content'
    elsif @custom_content.update_attributes(home_content_params)
      redirect_to action: :home, refresh: true
    else
      render 'edit_home_content'
    end
  end

  def destroy_home_content
    custom_content = HomePageContent.all.last
    custom_content.destroy
    redirect_to action: :home, refresh: true
  end

  def about
  end

  def contact
  end

  private

  def home_content_params
    params.require(:home_page_content).permit(:content)
  end
end
