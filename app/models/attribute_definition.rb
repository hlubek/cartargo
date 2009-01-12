class AttributeDefinition < ActiveRecord::Base
  belongs_to :content_definition
  
  validates_presence_of :name
  validates_presence_of :type

  # Overwrite STI default to enable use of 'type'
  self.inheritance_column = "type_id"
  
end
