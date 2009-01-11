class Backend::PagesController < ApplicationController

  before_filter :load_roots

  def index
  end

  def show
   @page = Page.find params[:id]
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
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:notice] = t(:updated_record, :name => t(:page))
      redirect_to backend_page_path(@page)
    else
      render :action => 'edit'
    end
  end

private
  def load_roots
    @roots = Page.roots
  end

end
