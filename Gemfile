source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Ruby interpreter version
ruby '>= 2.7.0'

# MYSQL database adapter
gem 'mysql2'

## PaperTrail for Version managment
gem 'paper_trail', '~> 14.0.0'
# Pundit for Authorization
gem 'pundit', '~> 2.3.0'
# Pundit Implications to handle permission implications
gem 'pundit_implications', '~> 0.1.0'
# Sorcery for Authentification
gem 'sorcery', '~> 0.17.0'
# awesome_print for Object Rendering
gem 'awesome_print', '~> 1.8.0'
# pagy for Paging
gem 'pagy', '~> 3.8.3'
# scenic for migrating views
gem 'scenic', '~> 1.8.0'
gem 'scenic_sqlite_adapter'
gem 'scenic-mysql_adapter'
# loaf for breadcrumbs
gem 'loaf', '~> 0.10.0'
# icons for buttons
gem 'material_icons', '~> 2.2.1'
# JQuery
gem 'jquery-rails', '~> 4.6.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Internationalization
gem 'rails-i18n'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'sprockets-rails', :require => 'sprockets/railtie'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'irb', require: false
  gem 'rdoc', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "sepa_king", "~> 0.14.0"
