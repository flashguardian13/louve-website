class BlogPostsController < ContentsController
  def show
    @content = model_class.find(params[:id])
    @facebook_metadata = {
      # 'fb:app_id' => 'APP_ID_HERE', <-- Find this value in your App Dashboard. Populate based on environment.
      'og:url' => blog_post_url(params[:id]),
      'og:type' => 'article',
      'og:title' => "Rhiannon Louve - #{@content.title}",
      'og:description' => @content.abstract || generate_abstract(@content.content),
      'og:image' => '/images/rhiannon_louve_logo_facebook.jpg'
    }
  end

  private

  def generate_abstract(str, word_count = 32)
    ends_of_words = (0...str.length).select { |i| str[i].match(/[a-z\-']/i) && (str[i + 1].nil? || str[i + 1].match(/[^a-z\-']/i)) }
    return str if ends_of_words.length <= word_count
    "#{str[0..ends_of_words[word_count - 1]]} ..."
  end

  def content_params
    params.require(:blog_post).permit(:title, :abstract, :content, :is_visible)
  end
end
