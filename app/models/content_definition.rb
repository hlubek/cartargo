class ContentDefinition < ActiveRecord::Base
  belongs_to :page
  has_many :attribute_definitions, :attributes => true

end
