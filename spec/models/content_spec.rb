require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Content do
  before(:each) do
    @valid_attributes = {
      :page_id => "1",
      :content_definition_id => "1",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Content.create!(@valid_attributes)
  end
end
