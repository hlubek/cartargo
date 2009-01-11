class CreateContentDefinitions < ActiveRecord::Migration
  def self.up
    create_table :content_definitions do |t|
      t.string :title
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :content_definitions
  end
end
