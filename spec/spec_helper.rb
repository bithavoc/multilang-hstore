$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'active_support'
require 'active_record'
require 'multilang-hstore'
require 'logger'

ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(:adapter => "postgresql", :host=>'127.0.0.1', :user=>'postgres')
begin
ActiveRecord::Base.connection.execute('CREATE DATABASE "multilang-hstore-test" WITH OWNER postgres;')
rescue ActiveRecord::StatementInvalid
  puts "Database already exists"
end
ActiveRecord::Base.establish_connection(:adapter => "postgresql", :database => "multilang-hstore-test", :host=>'127.0.0.1', :user=>'postgres')
ActiveRecord::Base.connection.execute('CREATE EXTENSION IF NOT EXISTS hstore;')

I18n.enforce_available_locales = false
I18n.available_locales = [:lv, :ru]
I18n.locale = I18n.default_locale = :lv

def setup_db
  ActiveRecord::Migration.verbose = false
  load "schema.rb"
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

#testable models
class AbstractPost < ActiveRecord::Base
end

class MinimalPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  multilang :title, :required => false
  multilang :body,  :required => false
end

class RegularPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  multilang :title, :required => true, :length => 25
  multilang :body,  :required => true, :length => 1000
end

class PartialPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  multilang :title
  multilang :body
end

class NamedPost < ActiveRecord::Base
  self.table_name = 'named_posts'
  multilang :title
end

class TacoPost < ActiveRecord::Base
  self.table_name = 'named_posts'
  multilang :title, required: [:lv, :ru]
end

class SloppyPost < ActiveRecord::Base
  self.table_name = 'named_posts'
  multilang :title, required: 1
end

class SanitizedPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  
  def self.squish(value)
    value.squish!
  end
  
  def self.sanitize_html(value)
    value.gsub!(/<\/?[^>]*>/, '')
  end
      
  multilang :title, sanitizer: method(:squish)
  multilang :body,  sanitizer: method(:sanitize_html)
end