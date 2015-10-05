$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'activerecord/search'
require 'activerecord/base.rb'
require 'minitest/autorun'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.new.create_table :cats do |t|
  t.column :name, :string
  t.column :description, :string
end

class Cat < ActiveRecord::Base
end
