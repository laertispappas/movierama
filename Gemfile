source 'https://rubygems.org'
ruby "2.2.1"

gem 'rails', '4.2.0'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'puma'
gem 'haml'
gem 'foundation-rails'
gem 'foundation-icons-sass-rails'

gem 'will_paginate', '~> 3.0.6'
gem 'will_paginate-foundation'
gem 'devise'
gem 'simple_form'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rails_12factor', group: :production


group :development do
  gem 'guard-rspec'
  gem 'libnotify'
  gem 'spring-commands-rspec'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'annotate', '~> 2.6.5' # annotate,  annotate --routes
  gem "rails_best_practices"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'faker'
  gem 'brakeman', :require => false # aset test your app brakeman [brakeman -o output.html -o output.json]
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end

