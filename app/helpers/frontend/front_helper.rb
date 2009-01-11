module Frontend::FrontHelper 
  def front_page_url(page)
    if page.instance_of? Hash
      route_path = page['route_path']
      domain = page['domain']
    else
      route_path = page.route_path
      domain = page.domain      
    end
    
    url_for(:controller => 'frontend/front', :action => 'show', :path => route_path, :host => domain, :port => 3000)
  end
end
