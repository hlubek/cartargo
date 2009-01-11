class AddDomainToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :domain, :string
  end

  def self.down
    remove_column :pages, :domain
  end
end
