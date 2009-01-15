module Backend::BackendHelper
  class ColumnDefinition    
    attr_reader :method, :options
  
    def initialize(template, method, options, block)
      @method = method
      @options = options
      @block = block
      @template = template
    end
    
    def label
      (options[:label] || @method.to_s)
    end
    
    def content(record)
      if @block
        @template.capture{ @block.call(record) }
      else
        @template.html_escape(record.send(@method).to_s)
      end
    end
  end

  class DatatableBuilder
    attr_reader :columns, :name
    
    def initialize(template, associated)
      @columns = []
      @associated = associated
      @template = template
    end
    
    def column(method, options = {}, &block)
      @columns << ColumnDefinition.new(@template, method, options, block)
    end
  end

  def render_datatable(associated, options = {}, &block)
  	associated = associated.is_a?(Array) ? associated : [associated]
  	unless associated.empty?
  	  name = extract_class_name(associated.first)
  	end
  	
  	builder = DatatableBuilder.new(@template, associated)
  	block.call(builder)
  	
  	concat(render(:partial => 'backend/shared/datatable', :locals => { :associated => associated, :options => options, :columns => builder.columns, :name => name }))
  end

  private   
    def extract_class_name(object)
      object.class.name.split('::').last.underscore
    end
end