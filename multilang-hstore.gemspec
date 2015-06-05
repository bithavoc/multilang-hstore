# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "multilang-hstore/version"

Gem::Specification.new do |s|
  s.name = 'multilang-hstore'
  s.version = Multilang::VERSION

  s.authors = ["Arthur Meinart", "bithavoc"]
  s.description = 'Model translations for Rails 3 backed by PostgreSQL and Hstore'
  s.licenses = ['MIT']
  s.email = 'im@bithavoc.io'
  s.files = `git ls-files`.split($/)
  s.homepage = "http://bithavoc.io/multilang-hstore/"
  s.require_paths = ["lib"]
  s.summary = %q{Model translations for Rails 3 and Rails 4 backed by PostgreSQL and Hstore}
  s.test_files = [
    "spec/multilang_spec.rb",
    "spec/schema.rb",
    "spec/spec_helper.rb"
  ]
  s.add_dependency 'activerecord', '~> 4.0'
  if (RUBY_PLATFORM == 'java')
    s.add_dependency 'activerecord-jdbcpostgresql-adapter'
  else
    s.add_dependency 'pg', '~> 0.0'
  end

end

