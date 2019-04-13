require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'Home Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @base_url = "http://localhost:3000/"
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end

  after(:all) do
    @driver.quit
  end

  it 'has welcome text' do
    e = @driver.find_element(css: '#welcome')
    expect(e.text).to include('Rhiannon Louve')
    expect(e.text).to include('Welcome!')
  end

  it 'has custom content' do
    e = @driver.find_element(css: 'body > div.content > div.post-content')
    expect(e.text).to include('something completely different')
  end

  it 'shows the first blog post' do
    posts = @driver.find_elements(css: 'body > div.content > div.post-container')
    expect(posts.length).to eq(1)
  end

  it 'shows a summary of the first publication' do
    publications = @driver.find_elements(css: 'body > div.content > div.publication-container')
    expect(publications.length).to eq(1)
  end

  it 'shows a news blurb' do
    news = @driver.find_element(css: 'body > div.content > div#news-and-events > h2')
    expect(news.text).to include('News and Events')
  end

  it 'does not show links to edit the custom content' do
    matches = @driver.find_elements(css: 'div#custom-content-links > a#custom-content-edit')
    expect(matches).to be_empty

    matches = @driver.find_elements(css: 'div#custom-content-links > a#custom-content-delete')
    expect(matches).to be_empty
  end

  context 'when signed in' do
    before(:all) do
      login_as_admin(@driver)
      wait_for_page_load(@driver) { @driver.navigate.to @base_url }
    end

    after(:all) do
      logout(@driver)
      wait_for_page_load(@driver) { @driver.navigate.to @base_url }
    end

    it 'shows links to edit the custom content' do
      link = @driver.find_element(css: 'div#custom-content-links > a#custom-content-edit')
      expect(link).to be_displayed
      expect(link.text).to eq('Edit')

      link = @driver.find_element(css: 'div#custom-content-links > a#custom-content-delete')
      expect(link).to be_displayed
    end

    context 'when editing the custom content' do
      before(:all) do
        wait_for_page_load(@driver) { @driver.find_element(css: 'div#custom-content-links > a#custom-content-edit').click }
      end

      it 'goes to the expected page' do
        expect(@driver.title).to eq("Edit Home Page Content | Rhiannon Louve")
        expect(@driver.current_url).to eq("http://localhost:3000/edit_home_content")
      end

      context 'when previewing changes' do
        before(:all) do
          text_box = @driver.find_element(css: '#home_page_content_content')
          text_box.clear
          text_box.send_keys('This is an automated test of the custom content preview option.')
          wait_for_page_load(@driver) { @driver.find_element(css: 'input[type="submit"][value="Preview"]').click }
        end

        it 'previews the changes on the right' do
          preview = @driver.find_element(css: 'body > div.content td.content-preview > div.post-content')
          expect(preview.text).to include('automated test of the custom content preview option')
        end

        context 'when saving changes' do
          before(:all) do
            wait_for_page_load(@driver) { @driver.find_element(css: 'input[type="submit"][value="Save"]').click }
          end

          it 'goes back to the home page' do
            expect(@driver.title).to eq("Home | Rhiannon Louve")
            expect(@driver.current_url).to eq("http://localhost:3000/?refresh=true")
          end

          it 'displays the new content' do
            custom_content = @driver.find_element(css: 'body > div.content > div.post-content')
            expect(custom_content.text).to include('automated test of the custom content preview option')
          end
        end
      end
    end

    context 'when cancelling a custom content edit' do
      before(:all) do
        @current_content = @driver.find_element(css: 'body > div.content > div.post-content').text

        wait_for_page_load(@driver) { @driver.find_element(css: 'div#custom-content-links > a#custom-content-edit').click }

        text_box = @driver.find_element(css: '#home_page_content_content')
        text_box.clear
        text_box.send_keys('This is an automated test of the custom content cancel option.')
        wait_for_page_load(@driver) { @driver.find_element(css: 'input[type="submit"][value="Preview"]').click }

        wait_for_page_load(@driver) do
          success = false
          until success
            begin
              @driver.find_element(css: 'form.edit_home_page_content > a[href="/"]').click
              success = true
            rescue Selenium::WebDriver::Error::UnknownError => e
              puts "document.readyState: #{@driver.execute_script("return document.readyState;")}"
              puts "jQuery.active: #{@driver.execute_script("return jQuery.active;")}"
              puts "window.turbolinks_is_busy: #{@driver.execute_script("return window.turbolinks_is_busy;")}"
            end
          end
        end
      end

      it 'goes back to the home page' do
        expect(@driver.title).to eq("Home | Rhiannon Louve")
        expect(@driver.current_url).to eq("http://localhost:3000/")
      end

      it 'displays the old content' do
        custom_content = @driver.find_element(css: 'body > div.content > div.post-content')
        expect(custom_content.text).to eq(@current_content)
        expect(custom_content.text).not_to include('automated test of the custom content cancel option')
      end
    end

    context 'when deleting the custom content' do
      before(:all) do
        @current_content = @driver.find_element(css: 'body > div.content > div.post-content').text

        @driver.execute_script('window.confirm = function() { return true; }')
        wait_for_page_load(@driver) { @driver.find_element(css: 'div#custom-content-links > a#custom-content-delete').click }
      end

      it 'removes the custom content' do
        matches = @driver.find_elements(css: 'body > div.content > div.post-content')
        expect(matches).to be_empty
      end

      it 'shows an add button instead of edit and delete' do
        link = @driver.find_element(css: 'div#custom-content-links > a#custom-content-edit')
        expect(link).to be_displayed
        expect(link.text).to eq('Add')

        matches = @driver.find_elements(css: 'div#custom-content-links > a#custom-content-delete')
        expect(matches).to be_empty
      end
    end

    context 'when adding new custom content' do
      before(:all) do
        wait_for_page_load(@driver) { @driver.find_element(css: 'div#custom-content-links > a#custom-content-edit').click }

        text_box = @driver.find_element(css: '#home_page_content_content')
        text_box.clear
        text_box.send_keys('And now for something completely different!')
        wait_for_page_load(@driver) { @driver.find_element(css: 'input[type="submit"][value="Save"]').click }
      end

      it 'sets the content appropriately' do
        custom_content = @driver.find_element(css: 'body > div.content > div.post-content')
        expect(custom_content.text).to eq('And now for something completely different!')
      end
    end
  end
end
