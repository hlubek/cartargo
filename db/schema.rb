# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090114231223) do

  create_table "attribute_definitions", :force => true do |t|
    t.integer  "content_definition_id"
    t.string   "name"
    t.string   "type"
    t.string   "options"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attribute_values", :force => true do |t|
    t.integer  "content_id"
    t.integer  "attribute_definition_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_definitions", :force => true do |t|
    t.string   "title"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", :force => true do |t|
    t.integer  "page_id"
    t.integer  "content_definition_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "container"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "domain"
    t.string   "route_path"
    t.text     "template"
  end

  add_index "pages", ["path", "parent_id"], :name => "path_parent_id", :unique => true
  add_index "pages", ["title", "parent_id"], :name => "title_parent_id", :unique => true

end
