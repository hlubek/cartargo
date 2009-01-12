class Content < ActiveRecord::Base
  belongs_to :page
  belongs_to :content_definition
  has_many :attribute_values
  
  acts_as_list :scope => :page
end
