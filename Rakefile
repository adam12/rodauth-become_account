require "rake/testtask"
require "rdoc/task"
require "rubygems/tasks"

RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/test*.rb"]
  t.verbose = true
end

Gem::Tasks.new

task default: :test
