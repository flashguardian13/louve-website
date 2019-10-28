require "selenium-webdriver"

require_relative 'selenium_helpers.rb'

require_relative 'page_wrappers/publications_index_page.rb'
require_relative 'page_wrappers/review_new_page.rb'

describe 'Publications Page' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome

    @publications_index_page = PublicationsIndexPage.new(@driver)
    @review_new_page = ReviewNewPage.new(@driver)

    @publications_index_page.go
  end

  after(:all) do
    @driver.quit
  end

  it 'contains one or more publications' do
    expect(@publications_index_page.publications.length).to be > 0
  end

  context 'when show more is clicked' do
    it 'displays more information' do
      publication = @publications_index_page.publications.first

      expect(publication.hidden_content).not_to be_displayed

      wait_for_page_load(@driver) { publication.show_more_button.click }
      expect(publication.hidden_content).to be_displayed
    end
  end

  context 'when signed in' do
    before(:all) do
      login_as_admin(@driver)
      @publications_index_page.go

      pub = @publications_index_page.publications.first
      wait_for_page_load(@driver) { pub.show_more_button.click } unless pub.hidden_content.displayed?
    end

    after(:all) do
      logout(@driver)
      @publications_index_page.go
    end

    it 'allows the creation of new publications' do
      expect(@publications_index_page.new_publication_link).to be_displayed
    end

    it 'allows publications to be hidden, shown, edited, and deleted' do
      pub = @publications_index_page.publications.first
      expect(pub.hide_link || pub.show_link).to be_displayed
      expect(pub.edit_link).to be_displayed
      expect(pub.delete_link).to be_displayed
    end

    it 'allows reviews to be hidden, shown, edited, and deleted' do
      rev = @publications_index_page.publications.first.reviews.first
      expect(rev.hide_link || rev.show_link).to be_displayed
      expect(rev.edit_link).to be_displayed
      expect(rev.delete_link).to be_displayed
    end

    it 'allows retailers to be hidden, shown, edited, and deleted' do
      ret = @publications_index_page.publications.first.retailers.first
      expect(ret.hide_link || ret.show_link).to be_displayed
      expect(ret.edit_link).to be_displayed
      expect(ret.delete_link).to be_displayed
    end

    context 'when adding a new review' do
      before(:all) do
        pub = @publications_index_page.publications.first
        wait_for_page_load(@driver) { pub.show_more_button.click } unless pub.hidden_content.displayed?

        wait_for_page_load(@driver) { pub.add_review_link.click }

        @review_new_page.quote.clear
        @review_new_page.quote.send_keys("I don't know this book half as well as I would like, and I like less than half of it half as well as it deserves.")
        @review_new_page.attribution.clear
        @review_new_page.attribution.send_keys("Bilbo Baggins")

        wait_for_page_load(@driver) { @review_new_page.add.click }

        @publications_index_page.go

        @publication = @publications_index_page.publications.first
        wait_for_page_load(@driver) { @publication.show_more_button.click } unless @publication.hidden_content.displayed?
      end

      it 'displays the new review' do
        expect(@publication.reviews.any? { |review| review.element.text.include?('half as well as I would like') }).to be true
        expect(@publication.reviews.any? { |review| review.element.text.include?('Bilbo Baggins') }).to be true
      end

      context 'when deleting the new review' do
        before(:all) do
          review = @publication.reviews.find { |review| review.element.text.include?('Bilbo Baggins') }
          skip_confirmation
          wait_for_page_load(@driver) { review.delete_link.click }

          @publications_index_page.go

          @publication = @publications_index_page.publications.first
          wait_for_page_load(@driver) { @publication.show_more_button.click } unless @publication.hidden_content.displayed?
        end

        it 'removes the review' do
          expect(@publication.reviews.none? { |review| review.element.text.include?('Bilbo Baggins') }).to be true
        end
      end
    end
  end
end
