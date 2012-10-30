# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "multilang-hstore/version"

Gem::Specification.new do |s|
  s.name = %q{multilang-hstore}
  s.version = Multilang::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Arthur Meinart", "Firebase.co"]
  s.date = %q{2012-10-29}
  s.description = %q{Model translations for Rails 3 backed by PostgreSQL and Hstore}
  s.email = %q{hello@firebase.co}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "lib/multilang-hstore.rb",
    "lib/multilang-hstore/active_record_extensions.rb",
    "lib/multilang-hstore/translation_keeper.rb",
    "lib/multilang-hstore/translation_proxy.rb",
    "lib/multilang-hstore/version.rb"
  ]
  s.homepage = %q{http://github.com/firebaseco/multilang-hstore}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Model translations for Rails 3 backed by PostgreSQL and Hstore}
  s.test_files = [
    "spec/multilang_spec.rb",
    "spec/schema.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

