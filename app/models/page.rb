class Page < ActiveRecord::Base
  acts_as_tree
  
  has_many :content_definitions
  has_many :contents, :order => 'position'
  
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :parent_id
  validates_format_of :path, :with => /\A[^\s\/]*\Z/
  validates_uniqueness_of :path, :scope => :parent_id
  
  # FIXME untested
  validates_uniqueness_of :domain, :scope => :route_path, :allow_blank => true
  
  before_save :generate_path_if_blank
  before_save :copy_domain_from_parent_if_blank
  before_save :generate_route_path
  
  named_scope :roots, :conditions => { :parent_id => nil }
  
  def content_by_container(container)
    contents.find_all_by_container(container, :include => :content_definition)
  end
  
  def inherited_content_definitions
    (parent ? parent.inherited_content_definitions : []) + content_definitions
  end
  
  # FIXME untested
  def template?
    !attributes['template'].blank?
  end
  
  def template
    if super.blank?
      parent.template unless parent.nil?
    else
      super
    end
  end

  def generate_route_path
    rp = rpath
    if rp.blank?
      self.route_path = nil
    else
      self.route_path = rp + '.html'
    end
  end
  
  # TODO refactor, ugly and long nested
  def containers
    t = Liquid::Template.parse(template)
    t.root.nodelist.select{ |t| t.kind_of? LiquidTags::ContainsBlock }.collect{ |c| c.container_name }
  end
  
  # FIXME untested
  def to_liquid
    {
      'id' => id,
      'title' => title,
      'domain' => domain,
      'path' => path,
      'route_path' => route_path,
      'created_at' => created_at,
      'updated_at' => updated_at,
      'parent' => parent,
      'children' => children
    }
  end

protected
  # recursive path of a page
  def rpath
    if (parent.nil? and domain) or (parent and parent.domain != domain)
      return ''
    else
      if parent
        rp = parent.rpath
        unless rp.blank?
          rp + '/' + path
        else
          path
        end
      else
        path
      end
    end
  end
  
private
  def generate_path_if_blank
    path_part_delimiter = '-'
    if path.blank?
      string = title.downcase
      # Convert some umlauts to ascii
      string.tr!('ŠŒŽšœžŸ¥µÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝàáâãåæçèéêëìíîïðñòóôõøùúûýÿ',
                 'SOZsozYYuAAAAAAACEEEEIIIIDNOOOOOOUUUUYaaaaaaceeeeiiiionooooouuuyy');
      string.gsub!(/ß/, 'ss')
      string.gsub!(/ä/, 'ae')
      string.gsub!(/ö/, 'oe')
      string.gsub!(/ü/, 'ue')
      # Convert non alphanum to spaces
      string.gsub!(/[^0-9a-zA-Z\s-]/, '')
      # Convert spaces to path_part_delimiter
      string.gsub!(/\s+/, path_part_delimiter)
      self.path = string
    end
  end
  
  def copy_domain_from_parent_if_blank
    if domain.blank? and parent
      self.domain = parent.domain
    end
  end
end
