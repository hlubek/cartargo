require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Frontend::FrontHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(Frontend::FrontHelper)
  end

  describe "method front_page_url" do
    it "should generate url from page.route_path" do
      page = mock_model(Page, :route_path => 'my_page.html', :domain => nil)
      helper.front_page_url(page).should == '/my_page.html'
    end
    
    it "should include domain if set" do
      page = mock_model(Page, :route_path => 'my_page.html', :domain => 'www.example.com')
      helper.front_page_url(page).should == 'http://www.example.com/my_page.html'
    end
  end
end
