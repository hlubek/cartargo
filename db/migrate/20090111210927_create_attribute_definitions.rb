class CreateAttributeDefinitions < ActiveRecord::Migration
  def self.up
    create_table :attribute_definitions do |t|
      t.integer :content_definition_id
      t.string :name
      t.string :type
      t.string :options

      t.timestamps
    end
  end

  def self.down
    drop_table :attribute_definitions
  end
end
