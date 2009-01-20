class Backend::PagesController < Backend::BackendController
  def index
  end

  def show
   @page = Page.with_contents.find(params[:id])
  end

  def new
    @page = Page.new
    if params[:page_id]
      @parent = Page.find(params[:page_id])
    end
  end

  def create
    if params[:page_id]
  	  @parent = Page.find(params[:page_id])
      @page = @parent.children.build(params[:page])
  	else
  	  @page = Page.build(params[:page])
  	end
  	
  	if @page.save
		flash[:notice] = t(:created_record, :name => t(:page))
		redirect_to backend_page_path(@page)
	else
		render :action => 'new'
	end
  end

  # FIXME untested
  def edit
    @page = Page.find params[:id]
  end

  # FIXME untested
  def update
    @page = Page.find params[:id]
    if @page.update_attributes(params[:page])
      flash[:notice] = t(:updated_record, :name => t(:page))
      redirect_to backend_page_path(@page)
    else
      render :action => 'edit'
    end
  end
  
  def sort_content
    @page = Page.find params[:id]
    container = params[:container]
    params["#{container}_list"].each_with_index do |id, position|
      content = @page.contents.find_by_id_and_container(id, container)
      content.update_attributes(:position => position + 1) if content
    end
    render :nothing => true
  end
  
  def move_content
    content_id = params[:id].split('_').last
    content = Content.find(content_id)
    if content.container != params[:container]
      content.update_attributes(:container => params[:container])
      @page = Page.with_contents.find(params[:page_id])
    end
    respond_to do |format|
      format.js # render move_content.rjs
    end      
  end
end
