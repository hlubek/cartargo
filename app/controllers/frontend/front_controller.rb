require 'liquid_tags'

class Frontend::FrontController < ApplicationController
  include Frontend::FrontHelper

  layout nil

  def show
    path = params[:path].blank? ? nil : params[:path].join('/')
    
    if path and request.domain.blank?
      # Find first root page
      @page = Page.find_by_parent_id_and_domain(nil, nil)
    elsif request.domain.blank?
      @page = Page.find_by_route_path_and_domain(path, nil)
    else
      @page = Page.with_contents.find_by_route_path_and_domain(path, request.domain)
    end

    @domain = request.domain   
    if @page.nil?
      @path = params[:path]
      render :template => 'frontend/front/404', :status => :not_found 
    else
      if @page.template
        container = {}
      	@page.containers.each do |c|
      	  container[c] = @page.content_by_container(c)
      	end
        render :text => Liquid::Template.parse(@page.template).render({ 'page' => @page }, :registers => { :controller => self, :container => container })
      else
        # render :error => 'No template'
      end
    end
  end
end
