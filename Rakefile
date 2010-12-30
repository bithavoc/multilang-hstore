require 'rake'
require 'rspec/core/rake_task'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'multilang', 'version')

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
  t.rspec_opts = ["-c"]
end

desc 'Generate documentation for the multilang plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Multilang'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "multilang"
    s.version = Multilang::VERSION
    s.summary = "Model translations"
    s.email = "artwork.lv@gmail.com"
    s.homepage = "http://github.com/artworklv/multilang"
    s.description = "Model translations"
    s.authors = ['Arthur Meinart']
    s.files =  FileList["[A-Z]*(.rdoc)", "{lib}/**/*", "init.rb"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end

