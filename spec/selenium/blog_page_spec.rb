require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

require_relative 'page_wrappers/blog_index_page.rb'
require_relative 'page_wrappers/blog_new_page.rb'

describe 'Blog Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @blog_index_page = BlogIndexPage.new(@driver)
    @blog_new_page = BlogNewPage.new(@driver)

    @blog_index_page.go
  end

  after(:all) do
    @driver.quit
  end

  it 'contains one or more blog posts' do
    expect(@blog_index_page.posts).not_to be_empty
  end

  context 'when viewing a blog post' do
    before(:all) do
      wait_for_page_load(@driver) { @blog_index_page.blog_visit_link(0).click }
    end

    it 'displays the post' do
      expect(@driver.find_element(css: 'body > div.content > div > div.post-content').text).not_to be_empty
    end

    after(:all) do
      @blog_index_page.go
    end
  end

  context 'when signed in' do
    before(:all) do
      login_as_admin(@driver)
      @blog_index_page.go
    end

    after(:all) do
      logout(@driver)
      @blog_index_page.go
    end

    it 'displays show, edit, and delete links' do
      expect(@blog_index_page.blog_edit_link(0)).to be_displayed
      expect(@blog_index_page.blog_delete_link(0)).to be_displayed
    end

    context 'when creating a new post' do
      before(:all) do
        wait_for_page_load(@driver) { @blog_index_page.new_post_link.click }

        @blog_new_page.title.clear
        @blog_new_page.title.send_keys('Title of the Blog Post')
        @blog_new_page.abstract.clear
        @blog_new_page.abstract.send_keys('Request to turn back time.')
        @blog_new_page.content.clear
        @blog_new_page.content.send_keys('Rectify my wrongs. Repetition of the Title of the Blog Post.')

        wait_for_page_load(@driver) { @blog_new_page.create.click }

        @test_post_index = @blog_index_page.find_post_index_by_title('Title of the Blog Post')
      end

      it 'shows the new post' do
        expect(@test_post_index).not_to be_nil
      end

      context 'when showing the new post' do
        before(:all) do
          wait_for_page_load(@driver) { @blog_index_page.blog_show_link(@test_post_index).click }
        end

        it 'makes the post visible to the public' do
          expect(@blog_index_page.posts[@test_post_index]['class'].scan(/\S+/)).not_to include('container-invisible')
        end

        context 'when hiding the new post' do
          before(:all) do
            wait_for_page_load(@driver) { @blog_index_page.blog_hide_link(@test_post_index).click }
          end

          it 'makes the post invisible to the public' do
            expect(@blog_index_page.posts[@test_post_index]['class'].scan(/\S+/)).to include('container-invisible')
          end
        end
      end

      context 'when deleting the new post' do
        before(:all) do
          skip_confirmation
          wait_for_page_load(@driver) { @blog_index_page.blog_delete_link(@test_post_index).click }
        end

        it 'removes the post' do
          expect(@blog_index_page.find_post_index_by_title('Title of the Blog Post')).to be_nil
        end
      end
    end
  end
end
