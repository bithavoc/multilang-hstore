# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "multilang-hstore/version"

Gem::Specification.new do |s|
  s.name = %q{multilang-hstore}
  s.version = Multilang::VERSION

  s.authors = ["Arthur Meinart", "Heapsource"]
  s.date = %q{2013-07-25}
  s.description = %q{Model translations for Rails 3 backed by PostgreSQL and Hstore}
  s.email = %q{hello@heapsource.com}
  s.files = [
    "lib/multilang-hstore.rb",
    "lib/multilang-hstore/active_record_extensions.rb",
    "lib/multilang-hstore/translation_keeper.rb",
    "lib/multilang-hstore/translation_proxy.rb",
    "lib/multilang-hstore/version.rb"
  ]
  s.homepage = %q{http://github.com/heapsource/multilang-hstore}
  s.require_paths = ["lib"]
  s.summary = %q{Model translations for Rails 3 backed by PostgreSQL and Hstore}
  s.test_files = [
    "spec/multilang_spec.rb",
    "spec/schema.rb",
    "spec/spec_helper.rb"
  ]
  s.add_dependency 'pg', '>= 0.0.1'
  s.add_dependency 'activerecord-postgres-hstore', '>= 0.7.5'
end

