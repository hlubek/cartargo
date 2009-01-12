class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :page_id
      t.integer :content_definition_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
