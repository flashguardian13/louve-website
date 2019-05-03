require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

describe 'Links Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @base_url = "http://localhost:3000/links"
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end

  after(:all) do
    @driver.quit
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

    context 'when creating a new link' do
      before(:all) do
        wait_for_page_load(@driver) { @driver.find_element(css: '#link-create-new').click }
      end

      it 'goes to the link creation page' do
        expect(@driver.current_url).to eq("http://localhost:3000/external_links/new")
      end

      context 'when previewing a new link' do
        before(:all) do
          @driver.find_element(css: '#external_link_url').send_keys('http://www.google.com')
          @driver.find_element(css: '#external_link_title').send_keys('Google')
          @driver.find_element(css: '#external_link_description').send_keys("It's Google. Who hasn't heard of Google?")
          wait_for_page_load(@driver) { @driver.find_element(css: '#new_external_link input[value="Preview"]').click }
        end

        it 'displays the correct preview on the right' do
          link = @driver.find_element(css: 'td.content-preview a')
          expect(link.text).to eq('Google')
          expect(link['href']).to eq('http://www.google.com/')

          desc = @driver.find_element(css: 'td.content-preview div.link-description')
          expect(desc.text).to include?('heard of Google')
        end

        context 'when submitting a new link' do
          before(:all) do
            wait_for_page_load(@driver) { @driver.find_element(css: '#new_external_link input[value="Create"]').click }
            link_containers = @driver.find_elements(css: 'div.link-container')
            @link_container = link_containers.select { |link_container| link_container.text.match(/Google/) }.first
          end

          it 'displays the newly created link' do
            link = @link_container.find_element(css: 'div.link-title > a')
            desc = @link_container.find_element(css: 'div.link-description')

            expect(link.text).to eq('Google')
            expect(link['href']).to eq('http://www.google.com/')
            expect(desc.text).to include?('heard of Google')
          end

          it 'allows the new link to be shown, edited, or deleted' do
            link_show = @link_container.find_element(css: 'div.link-admin > a.link-show')
            link_edit = @link_container.find_element(css: 'div.link-admin > a.link-edit')
            link_delete = @link_container.find_element(css: 'div.link-admin > a.link-delete')

            expect(link_show['href']).to match(%r{/external_links/\d+})
            expect(link_edit['href']).to match(%r{/external_links/\d+/edit})
            expect(link_delete['href']).to match(%r{/external_links/\d+})
          end

          context 'when deleting the link' do
            before(:all) do
              skip_confirmation
              wait_for_page_load(@driver) { @link_container.find_element(css: 'div.link-admin > a.link-delete').click }
            end

            it 'no longer displays the link' do
              link_containers = @driver.find_elements(css: 'div.link-container')
              if link_containers.empty?
                expect(link_containers).to be_empty
              else
                matches = link_containers.select { |link_container| link_container.text.match(/Google/) }
                expect(matches).to be_empty
              end
            end
          end
        end
      end
    end
  end
end
