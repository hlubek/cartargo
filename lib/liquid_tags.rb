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
end
