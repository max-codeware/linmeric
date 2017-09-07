
require "bundler/gem_tasks"
require "rdoc/task"
task :default => :spec

desc "Generates the documentation in ./doc"
RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_dir = "./doc"
  rdoc.rdoc_files.include("README.md","lib/*/*.rb")
  rdoc.options << "--all"
end


desc "Builds the gem locally"
task :build do
  CLEAN << Dir["*.gem"]
  puts "Building gem..."
  (Dir["*.gemspec"]).each do |gs|
    `gem build #{gs}`
  end
  puts "Gem succesfully built"
end

desc "Uninstalls the gem"
task :uninstall do
  puts "Uninstalling previous versions of linmeric if installed"
  `echo gem uninstall linmeric`
end

desc "Installs the built gem locally"
task :install  do
  puts "Installing the last version of linmeric from local built gem"
  gem = Dir["*.gem"].sort.last
  `gem install #{gem}`
  puts "Gem successfully installed"
end

#task :make => [:build]


