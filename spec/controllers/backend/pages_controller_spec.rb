require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Backend::PagesController do

  def mock_page(stubs={})
    @mock_page ||= mock_model(Page, stubs)
  end

  describe "responding to GET index" do
    it "should expose all root pages as @pages" do
      Page.should_receive(:roots).and_return([mock_page])
      get :index
      assigns[:roots].should == [mock_page]
    end
  end

  describe "responding to GET show" do
    it "should expose the requested page as @page" do
      Page.should_receive(:find).with("37").and_return(mock_page)
      get :show, :id => "37"
      assigns[:page].should equal(mock_page)
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
    end
  end
end
