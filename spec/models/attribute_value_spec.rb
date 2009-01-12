require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttributeValue do
  before(:each) do
    @valid_attributes = {
      :content_id => "1",
      :attribute_definition_id => "1",
      :value => "value for value"
    }
  end

  it "should create a new instance given valid attributes" do
    AttributeValue.create!(@valid_attributes)
  end
end
