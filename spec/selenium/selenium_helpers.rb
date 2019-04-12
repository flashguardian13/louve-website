def get_children(element)
  element.find_element(xpath: './*')
end

def get_parent(element)
  element.find_element(xpath: './..')
end

def inspect_element(element)
  classes = element['class'].scan(/\S+/)
  classes_suffix = classes.any? ? ".#{classes.join('.')}" : ''

  position_string = "at (#{element.rect.x}, #{element.rect.y}), #{element.rect.width} x #{element.rect.height}"

  [
    "#{element.tag_name}#{classes_suffix}, #{position_string}",
    "#{element.text[0...128]}"
  ].join("\n")
end

def wait_for_page_load
  sleep(1)
  wait = Selenium::WebDriver::Wait.new(:timeout => 60)
  wait.until { @driver.execute_script("return document.readyState == 'complete' && jQuery.active == 0 && !window.turbolinks_is_busy") }
end

def attach_turbolinks_listeners(driver)
  driver.execute_script('document.addEventListener("turbolinks:before-visit", function() { window.turbolinks_is_busy = true; });')
  driver.execute_script('document.addEventListener("turbolinks:load", function() { window.turbolinks_is_busy = false; });')
end
