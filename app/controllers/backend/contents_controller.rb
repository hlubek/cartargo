class Backend::ContentsController < Backend::BackendController
  before_filter :load_page

  def index
  end

  def show
  end

  def new
    content_definition = ContentDefinition.find(params[:content_definition_id])
    @content = @page.contents.new(:content_definition => content_definition, :container => params[:container])
    @content.content_definition.attribute_definitions.map do |ad|
      @content.attribute_values.build(:attribute_definition => ad)
    end
  end
  
  def create
    @content = @page.contents.build(params[:content])
  	
  	if @content.save
		flash[:notice] = t(:created_record, :name => t(:content))
		redirect_to backend_page_path(@page)
	else
		render :action => 'new'
	end
  end

  def edit
  end
  
private
  def load_page
    if params[:page_id]
      @page = Page.find(params[:page_id])
    end
  end
end
