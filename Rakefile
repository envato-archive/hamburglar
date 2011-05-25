$:.unshift 'lib'

begin
  require 'bundler'
  Bundler::GemHelper.install_tasks
rescue LoadError
  puts "Please install bundler (gem install bundler)"
  exit
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new :spec
rescue LoadError
  puts "Please install rspec (bundle install)"
  exit
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/hamburglar.rb -I ./lib"
end

task :default => :spec
