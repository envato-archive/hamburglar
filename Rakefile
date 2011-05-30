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

begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.rcov[:rcov_opts] << "-Ispec"
  end
rescue LoadError
  # puts "Can't find metric_fu"
end

begin
  require 'rcov'
  desc  "Run all specs with rcov"
  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/,features\/}
  end
rescue LoadError
  # puts "Can't find rcov"
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/hamburglar.rb -I ./lib"
end

task :default => :spec
