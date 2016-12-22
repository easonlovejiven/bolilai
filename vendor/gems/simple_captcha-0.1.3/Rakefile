require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "simple_captcha"
    gem.summary = %Q{SimpleCaptcha is the simplest and a robust captcha.}
    gem.description = %Q{SimpleCaptcha is the simplest and a robust captcha. Its implementation requires adding up a single line in views and in controllers/models. SimpleCaptcha is available to be used with Rails2.0 or above and also it provides the backward compatibility with previous versions of Rails.}
    gem.email = "joloudov@gmail.com"
    gem.homepage = "http://github.com/joloudov/simple_captcha"
    gem.authors = ["joloudov"]
    gem.add_development_dependency "rails", ">= 2.3.7"
    gem.files = [
      '[A-Z]*',
      '*.rb',
      'assets/**/*.rb',
      'assets/**/**/*.erb',
      'lib/*.rb',
      'tasks/*.rake',
    ]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

desc 'Test the simple_captcha plugin.'
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

desc 'Generate documentation for the simple_captcha.'
require 'rake/rdoctask'
Rake::RDocTask.new(:rdoc) do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SimpleCaptcha'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
