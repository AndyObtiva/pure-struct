# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "pure-struct"
  gem.homepage = "http://github.com/AndyObtiva/pure-struct"
  gem.license = "MIT"
  gem.summary = %Q{Pure Ruby Re-Implementation of Struct}
  gem.description = %Q{Pure Ruby re-implementation of Struct to ensure cross-Ruby functionality where needed (e.g. Opal)}
  gem.email = "andy.am@gmail.com"
  gem.authors = ["Andy maleh"]

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "pure-struct #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
