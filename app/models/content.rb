class Content < ActiveRecord::Base
  belongs_to :page
  belongs_to :content_definition
  has_many :attribute_values, :attributes => true
  
  acts_as_list :scope => :page
  
  def [](key)
    av = attribute_values.select{ |av| av.attribute_definition.name == key.to_s }.first
    av.value if av
  end
  
end
