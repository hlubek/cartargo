class Content < ActiveRecord::Base
  belongs_to :page
  belongs_to :content_definition
  has_many :attribute_values, :attributes => true
  
  acts_as_list :scope => :page
  
  validates_presence_of :content_definition
  
  def label
    hash = to_liquid
    hash['title'] if hash['title']
  end
  
  def to_liquid
    hash = {} # { :content_definition => content_definition }
    attribute_values.each do |av|
      hash[av.attribute_definition.name] = av.value
    end
    hash
  end
end
