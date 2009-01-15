class AddContainerToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :container, :string
  end

  def self.down
    remove_column :contents, :container
  end
end
