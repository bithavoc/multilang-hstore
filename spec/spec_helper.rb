$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'active_support'
require 'active_record'
require 'activerecord-postgres-hstore/activerecord'
require 'activerecord-postgres-hstore/coder'
require 'multilang-hstore'
require 'logger'

ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(:adapter => "postgresql", :database => "multilang-hstore-test", :host=>'127.0.0.1', :user=>'postgres')

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
  serialize :title, ActiveRecord::Coders::Hstore
  serialize :body, ActiveRecord::Coders::Hstore
end

class MinimalPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  multilang :title, :required => false,  :accessible => true
  multilang :body,  :required => false, :accessible => true
  attr_accessible :void
end

class RegularPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  multilang :title, :required => true, :length => 25,   :accessible => true
  multilang :body,  :required => true, :length => 1000, :accessible => true
  attr_accessible :void
end

class ProtectedPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  multilang :title, :accessible => false
  multilang :body,  :accessible => false
  attr_accessible :void
end

class PartialPost < ActiveRecord::Base
  self.table_name = 'abstract_posts'
  multilang :title
  multilang :body
  attr_accessible :void
end
