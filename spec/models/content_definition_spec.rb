require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContentDefinition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :page_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ContentDefinition.create!(@valid_attributes)
  end
end
