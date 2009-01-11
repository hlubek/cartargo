require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Frontend::FrontController do

  def mock_page(stubs={})
    @mock_page ||= mock_model(Page, { :template => nil }.merge(stubs))
  end

  #Delete these examples and add some real ones
  it "should use Frontend::FrontController" do
    controller.should be_an_instance_of(Frontend::FrontController)
  end


  describe "GET 'show'" do
    describe "without path and subdomain" do
      it "should load the first root page without a domain" do
        request.stub!(:domain).and_return(nil)
        Page.should_receive(:find_by_parent_id_and_domain).with(nil, nil).and_return(mock_page)
        get 'show'
        assigns[:page].should equal(mock_page)
      end
    end

    describe "with path but without subdomain" do
      it "should find a page by route_path without domain" do
        request.stub!(:domain).and_return(nil)
        Page.should_receive(:find_by_route_path_and_domain).with('foo/bar.html', nil).and_return(mock_page)
        get 'show', :path => ['foo', 'bar.html']
        assigns[:page].should equal(mock_page)
      end
    end

    describe "with path and subdomain" do
      it "should find a page by route_path and domain" do
        request.stub!(:domain).and_return('www.example.com')
        Page.should_receive(:find_by_route_path_and_domain).with('foo.html', 'www.example.com').and_return(mock_page)
        get 'show', :path => 'foo.html'
        assigns[:page].should equal(mock_page)
      end
    end
    
    describe "with unknown path" do
      it "should render a 404" do
        get 'show', :path => 'imnotthere.html'
        response.status.should == '404 Not Found'
        response.should render_template('frontend/front/404')
      end

      it "should assign path and domain" do
        request.stub!(:domain).and_return('www.example.com')
        get 'show', :path => 'imnotthere.html'
        assigns[:path].should == 'imnotthere.html'
        assigns[:domain].should == 'www.example.com'
      end
    end
    
    describe "with page having a template" do
      it 'should render the page template' do
        request.stub!(:domain).and_return(nil)
        mock_page(:title => 'Foo bar', :path => 'foo-bar', :template => 'My template')
        Page.should_receive(:find_by_route_path_and_domain).with('foo-bar.html', nil).and_return(mock_page)
        lt = mock(Liquid::Template)
        Liquid::Template.should_receive(:parse).with(mock_page.template).and_return(lt)
        lt.should_receive(:render).with({ 'page' => mock_page }, :registers => { :controller => controller }).and_return('Template output')
        get 'show', :path => ['foo-bar.html']
        response.should have_text('Template output')
      end
    end
  end
  
  describe "- route generation" do
    it "should map { :action => 'show ', :path => page.route_path } to /path" do
      route_for(:controller => 'frontend/front', :action => 'show', :path => 'my_page.html').should == '/my_page.html'
    end
  end
  
  describe "- route recoginition" do
    it "should generate params { :action => 'show ', :path => path } from /path" do
      params_from(:get, '/my_page.html').should == {:controller => 'frontend/front', :action => 'show', :path => ['my_page.html'] }
    end
  end
end
