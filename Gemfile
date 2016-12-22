# source 'https://rubygems.org'
source 'https://ruby.taobao.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'mysql2', '0.3.20'
# Use sqlite3 as the database for Active Record
# # Use SCSS for stylesheets

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

###前端
# gem 'bootstrap-sass'
gem 'remotipart', '~> 1.2'
gem "non-stupid-digest-assets"
gem 'themes_on_rails','0.3.0',:path => "vendor/gems/themes_on_rails-0.3.0", :require => "themes_on_rails"
gem "phantomjs"
#权限
# gem 'devise', '3.4.0'
# gem 'simple_captcha', :git => 'git://github.com/galetahub/simple-captcha.git'
gem 'simple_captcha', '0.1.3', :path => "vendor/gems/simple_captcha-0.1.3", :require => "simple_captcha"
# gem 'devise-async', '~>0.9.0'
gem 'omniauth', "1.2.2"
gem 'omniauth-oauth2', "1.2.0"
# gem 'cancan', '~> 1.6.10'
#rails
gem "activeresource"
#cache
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

#图片处理
gem 'carrierwave', '>=0.6.2'
gem 'carrierwave-qiniu', '~> 0.1.0'
# gem 'qiniu-rs', '~> 3.4.9'
gem "rmagick"
gem "mini_magick"
#数据处理
gem "spreadsheet"
#数据库
gem "modular_migration", "0.0.4"
gem 'dynamic_form'
gem 'awesome_nested_set'
# gem "redis", "3.1.0"
# gem "redis-namespace", "1.5.1"
gem "redis-store", "1.1.7"
gem "redis-rails"
#模板
gem 'kaminari', '0.16.3'
gem 'slim', '2.0.2'
gem 'haml'
#后台运行
gem 'sidekiq', '~> 3.2.1'
gem 'whenever', :require => false
#http访问
gem 'rest-client', '1.8.0'
gem 'soap4r-spox'
gem 'httparty'
gem 'mechanize'
#加密
gem "ruby-hmac", "~> 0.4.0", require: 'hmac-md5'

gem 'acts-as-taggable-on', '~> 3.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# group :assets do
# gem 'sass-rails'
#前端
gem 'sass-rails'
gem 'compass-rails', github: 'Compass/compass-rails', branch: 'master'
# gem 'compass-recipes'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# end

group :development, :test do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'capistrano-rails-console'
  gem "capistrano-db-tasks", require: false
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'unicorn'
end
