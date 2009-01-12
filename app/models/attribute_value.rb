class AttributeValue < ActiveRecord::Base
  belongs_to :content
  belongs_to :attribute_definition
end
