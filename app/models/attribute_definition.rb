class AttributeDefinition < ActiveRecord::Base
  # Overwrite STI default to enable use of 'type'
  self.inheritance_column = "type_id"
end
