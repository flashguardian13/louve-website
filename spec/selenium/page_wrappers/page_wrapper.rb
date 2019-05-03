class PageWrapper
  attr_accessor :base_url

  def initialize(driver, base_url)
    @driver = driver
    @base_url = base_url
  end

  def go
    wait_for_page_load(@driver) { @driver.navigate.to @base_url }
  end
end
