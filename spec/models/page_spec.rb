require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  include Matchers::ActiveRecordMatchers
  fixtures :pages

  before(:each) do
    @valid_attributes = {
      :title => "A random page title",
      :path => "my_random_path"
    }
  end
  
  it 'should have named scope roots for root pages' do
    Page.should have_named_scope(:roots, :conditions => {:parent_id => nil})
  end
  
  describe 'domain' do
    it 'should be an attribute' do
      page = Page.new(@valid_attributes.merge(:domain => 'www.foobar.com'))
      page.should be_valid
    end
    
    # TODO spec format of domain
    
    it 'should be set from parent if blank on save' do
      root = Page.create!(:title => 'Test root', :domain => 'www.foobar.com')
      page = root.children.create!(:title => 'Foo bar')
      page.domain.should == root.domain
    end
    
    it 'should be not forced to unique if blank' do
		# how to test it nicely?     
    end
  end
  
  describe 'template' do
    it 'should be an attribute' do
      page = Page.new(@valid_attributes.merge(:template => '<html><!--Template--></html>'))
      page.should be_valid
    end
    
    it 'should be loaded from parent if blank' do
      pages(:root).template = 'Test'
      pages(:first_child).parent = pages(:root) # This has to be set explicitly (why?)
      pages(:first_child).template.should == 'Test'	
    end
  end
  
  describe 'template containers' do
    it 'should return the defined containers' do
      pages(:page_with_containers).containers.should == ['main', 'left']
    end
    
    it 'should be empty if the page defines no containers' do
      pages(:page_without_containers).containers.should be_empty
    end
  end

  describe 'title' do  
    it 'should be mandatory' do
      page = Page.new(@valid_attributes.except(:title))
      page.should have_error_on(:title, :blank)
    end
  
    def create_duplicate_page_title(base)
      base.create!(:title => 'my duplicate page')
      base.create(:title => 'my duplicate page')
    end
    
    it 'should be unique on root' do
      page = create_duplicate_page_title(Page)
      page.should have_error_on(:title, :taken)
    end

    it 'should be unique on each level' do
      page = create_duplicate_page_title(pages(:root).children)
      page.should have_error_on(:title, :taken)
    end
  end

  describe 'path' do    
    describe 'when blank and generated' do
      it 'should transform the title' do
        page = Page.create!(:title => 'My special title');
        page.path.should == 'my-special-title'
      end
      
      it 'should not be valid with slashes' do
        page = Page.new(@valid_attributes.merge(:path => 'foo/bar'));
        page.should have_error_on(:path, :invalid)
      end     
      
      it 'should eliminate duplicate spaces' do
        page = Page.create!(:title => 'My special  title');
        page.path.should == 'my-special-title'
      end
      
      it 'should convert umlauts' do
        page = Page.create!(:title => 'My ßpeciäl Tütle');
        page.path.should == 'my-sspeciael-tuetle'
      end      
      
      it 'should strip non alphanum chars' do
        page = Page.create!(:title => 'My special title (with something else)+');
        page.path.should == 'my-special-title-with-something-else'
      end
    end
    
    describe 'when not blank' do
      it 'should be stored as is' do
        page = Page.create!(:title => 'Foo Bar', :path => 'foo-bar');
        page.should_not have_errors
      end
    end

    it 'should have no spaces' do
      page = Page.new(@valid_attributes.merge(:path => 'my path'))
      page.should have_error_on(:path, :invalid)
    end
    
    def create_duplicate_page_path(base)
      base.create!(:title => 'page 1', :path => 'my_duplicate_path')
      base.create(:title => 'page 2', :path => 'my_duplicate_path')
    end
    
    it 'should be unique on root' do
      page = create_duplicate_page_path(Page)
      page.should have_error_on(:path, :taken)
    end

    it 'should be unique on each level' do
      page = create_duplicate_page_path(pages(:root).children)
      page.should have_error_on(:path, :taken)
    end
  end
  
  describe 'without parent' do
    it 'should have nil parent property' do
      pages(:root).parent.should be_nil
    end
  end
  
  describe 'with parent' do
    it 'should reference the parent in the parent property' do
      pages(:first_child).parent.should == pages(:root)
    end
  end
  
  describe 'route_path' do 
    it 'should generate and append suffix to path' do
      page = Page.create!(:title => 'foo')
      page.route_path.should == 'foo.html'
    end
    
    it 'should be empty for page with domain' do
      domain_page = Page.create!(:title => 'foo', :path => 'foo', :domain => 'www.foobar.com')
      domain_page.route_path.should be_nil
    end
    
    it 'should prefix parent paths' do
      page = Page.create!(:title => 'foo', :path => 'foo')
      child = page.children.create!(:title => 'First child', :path => 'first-child')
      child.route_path.should == 'foo/first-child.html'
    end
    
    it 'should not start with slash for domain parent' do
      page = Page.create!(:title => 'foo', :domain => 'www.foo.com')
      child = page.children.create!(:title => 'First child', :path => 'first-child')
      child.route_path.should == 'first-child.html'
    end
  end

  describe 'being created' do
    before do
      @page = nil
      @creating_page = lambda do
        @page = Page.create!(@valid_attributes)
        @page.should_not have_errors
      end
    end

    it 'increments Page#count' do
      @creating_page.should change(Page, :count).by(1)
    end
  end
end
