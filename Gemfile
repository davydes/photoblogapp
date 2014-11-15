source 'https://rubygems.org'

gem 'rails', '~> 4.1.6'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'bcrypt', '~> 3.1.7'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery_mobile_rails', '1.4.4'

gem 'russian'
gem 'twitter-bootstrap-rails', '3.2.0'
gem 'bootstrap-datepicker-rails'
gem 'paperclip', '~> 4.2'
gem 'recaptcha', :require => 'recaptcha/rails'

gem 'spring',  group: :development
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby
gem 'less-rails', '2.5.0'
gem "redcarpet"

group :test do
  gem 'codeclimate-test-reporter',  require: nil
  gem 'timecop'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'fog' , :git => 'https://github.com/fog/fog.git'
  gem 'unicorn'
end

ruby '2.1.3'
