module Frontend::FrontHelper 
  def front_page_url(page)
    if page.instance_of? Hash
      route_path = page['route_path']
      domain = page['domain']
    else
      route_path = page.route_path
      domain = page.domain      
    end
    
    #url = url_for(:controller => 'frontend/front', :action => 'show', :host => domain, :port => 3000)
    #url + route_path if route_path
    
    port = AppConfig.frontend && AppConfig.frontend.port ? ":" + AppConfig.frontend.port.to_s : ''
    path = route_path ? route_path : ''
    "http://" + domain + port + "/" + path
  end
end
