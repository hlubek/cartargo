module Backend::PagesHelper
  include Backend::BackendHelper
  
  # FIXME untested
  def tree_ul(acts_as_tree_set, init = true, &block)
    if acts_as_tree_set.size > 0
      ret = '<ul>'
      acts_as_tree_set.collect do |item|
        next if item.parent_id && init
        li_options = {}
        li_content = yield item, li_options
        li_attributes = li_options.collect { |key, value| "#{key}=\"#{value}\"" }.join(' ')
        ret += "<li #{li_attributes}>"
        ret += li_content
        ret += tree_ul(item.children, false, &block) if item.children.size > 0
        ret += '</li>'
      end
      ret += '</ul>'
    end
  end
  
  def content_in_containers_except(container)
    @page.containers.select{ |c| c != container }.collect{ |c| "content_in_container_#{c}" }
  end
end
