source 'https://rubygems.org'

gem 'rails', '~> 4.0.13'

gem 'pg'

gem 'sass-rails', '~> 4.0.3'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.0.3'

gem 'slim'

gem 'backbone-rails'
gem 'underscore-rails'
gem 'therubyracer'
gem 'jquery-rails'
gem 'less-rails'
gem 'twitter-bootstrap-rails', '=2.2.8'

gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'pusher'

gem 'friendly_id', '5.0.3'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-unicorn', require: false
  gem 'foreman', require: false
end


group :development, :test do
  gem 'dotenv-rails'
  gem 'jasminerice', git: 'https://github.com/bradphelan/jasminerice.git'

  gem 'guard'
  gem 'guard-jasmine'

  gem 'guard-minitest'

  gem "mocha", :require => false

  gem 'spork-rails'
  gem 'spork-testunit'
end
