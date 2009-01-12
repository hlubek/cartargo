class CreateAttributeValues < ActiveRecord::Migration
  def self.up
    create_table :attribute_values do |t|
      t.integer :content_id
      t.integer :attribute_definition_id
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :attribute_values
  end
end
