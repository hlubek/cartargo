require 'liquid_tags'
 
Liquid::Template.register_tag('link_to', LiquidTags::LinkToTag)
Liquid::Template.register_tag('contains', LiquidTags::ContainsBlock)
