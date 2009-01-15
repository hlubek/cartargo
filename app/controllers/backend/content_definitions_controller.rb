# FIXME untested
class Backend::ContentDefinitionsController < ApplicationController
  layout "backend/standard-layout"

  before_filter :load_page

  def index
  end

  def show
  end

  def new
    @content_definition = @page.content_definitions.build
  end
  
  def create
    @content_definition = @page.content_definitions.build(params[:content_definition])
  	
  	if @content_definition.save
		flash[:notice] = t(:created_record, :name => t(:content_definition))
		redirect_to @page
	else
		render :action => 'new'
	end
  end

  def edit
    @content_definition = @page.content_definitions.find(params[:id])
  end
  
  def update
    @content_definition = @page.content_definitions.find(params[:id])
    if @content_definition.update_attributes(params[:content_definition])
      flash[:notice] = t(:updated_record, :name => t(:content_definition))
      redirect_to backend_page_content_definition_path(@page, @content_definition)
    else
      render :action => 'edit'
    end
  end
  
private
  def load_page
    if params[:page_id]
      @page = Page.find(params[:page_id])
    end
  end
end
