class AddRoutePathToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :route_path, :string
  end

  def self.down
    remove_column :pages, :route_path
  end
end
