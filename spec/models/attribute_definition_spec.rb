require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttributeDefinition do
  before(:each) do
    @valid_attributes = {
      :content_definition_id => "1",
      :name => "value for name",
      :type => "value for type",
      :options => "value for options"
    }
  end

  it "should create a new instance given valid attributes" do
    AttributeDefinition.create!(@valid_attributes)
  end
end
