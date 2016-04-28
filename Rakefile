require "bundler/gem_tasks"
require 'rspec'

tasks = [:build]
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  tasks.unshift( :spec )
rescue LoadError
end


task :default => tasks
