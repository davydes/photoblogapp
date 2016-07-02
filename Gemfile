source 'https://rubygems.org'

gem 'rails', '~>4.2'
gem 'jbuilder'
gem 'bcrypt', '~>3.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'russian'
gem 'twitter-bootstrap-rails', '~>3.0'
gem 'bootstrap-datepicker-rails'
gem 'paperclip', '~> 4.3'
gem 'recaptcha', :require => 'recaptcha/rails'

gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer',  platforms: :ruby
gem 'less-rails'
gem "redcarpet"
gem 'mini_exiftool_vendored'
gem 'kaminari'
gem 'i18n-inflector-rails'
gem 'responders'

group :test do
  gem 'codeclimate-test-reporter',  require: nil
  gem 'timecop'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'sqlite3'
  gem "ruby-prof"
  gem 'spring'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'fog' , :git => 'https://github.com/fog/fog.git'
  gem 'unicorn'
  gem 'yui-compressor'
end
