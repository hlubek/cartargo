module LiquidTags
  class LinkToTag < Liquid::Tag
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TagHelper
    include Frontend::FrontHelper
  
    Syntax = /([^\s]+),\s*([^\s]+)/
    def initialize(tag_name, params, tokens)
      if params =~ Syntax
        @label = $1
        @target = $2
      else
        raise SyntaxError.new("Syntax Error in 'link' - Valid syntax: link [label], [target]")
      end
    end

    def render(context)
      # front_page_url(context[@page])
      # context.registers[:controller].front_page_url(context[@page])
      @request = context.registers[:request]
      link_to context[@label], context.registers[:controller].front_page_url(context[@target])
    end
  end
  
  class ContainsBlock < Liquid::Block
    Syntax = /(\w+)\s+in\s+(\w+)/
    
    attr_reader :container_name, :attributes
    
    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @variable_name = $1
        @container_name = $2
        @name = "#{$1}-#{$2}"
        @attributes = {}
        markup.scan(Liquid::TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        raise SyntaxError.new("Syntax Error in 'contains block' - Valid syntax: contains [item] in [container]")
      end

      super
    end
  
    def render(context)        
      context.registers[:contains] ||= Hash.new(0)

      return 'no container set' if context.registers[:container].nil?

      container = context.registers[:container][@container_name]
    
      return '' if container.nil? or container.empty?
    
      range = (0..container.length)
    
      if @attributes['limit'] or @attributes['offset']
        offset = 0
        if @attributes['offset'] == 'continue'
          offset = context.registers[:contains][@name] 
        else          
          offset = context[@attributes['offset']] || 0
        end
        limit  = context[@attributes['limit']]

        range_end = limit ? offset + limit : container.length
        range = (offset..range_end-1)
      
        # Save the range end in the registers so that future calls to 
        # offset:continue have something to pick up
        context.registers[:contains][@name] = range_end
      end
            
      result = []
      segment = container[range]
      return '' if segment.nil?

      context.stack do 
        length = segment.length
      
        segment.each_with_index do |item, index|
          context[@variable_name] = item
          context['container'] = {
            'name'    => @name,
            'length'  => length,
            'index'   => index + 1, 
            'index0'  => index, 
            'rindex'  => length - index,
            'rindex0' => length - index -1,
            'first'   => (index == 0),
            'last'    => (index == length - 1) }
        
          result << render_all(@nodelist, context)
        end
      end
    
      # Store position of last element we rendered. This allows us to do 
    
      result 
    end
  end
end
