class AddTitleAndParentIndicesToPage < ActiveRecord::Migration
  def self.up
    add_index :pages, [:title, :parent_id], :unique => true, :name => 'title_parent_id'
    add_index :pages, [:path, :parent_id], :unique => true, :name => 'path_parent_id'
  end

  def self.down
    remove_index :pages, 'title_parent_id'
    remove_index :pages, 'path_parent_id'
  end
end
