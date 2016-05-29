require 'bundler/gem_tasks'

tasks = [:build]
begin
  require 'rspec'
  require 'rspec/core/rake_task'
  require 'quality/rake/task'
  RSpec::Core::RakeTask.new(:spec)
  Quality::Rake::Task.new do |t|
    t.verbose = true
  end
  tasks.unshift(:spec)
  tasks << :quality
rescue LoadError => e
  e
end

task default: tasks
