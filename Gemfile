source 'https://rubygems.org'
#source 'https://rails-assets.org'

ruby '2.6.3'
gem 'rails', '4.2.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  platforms: :ruby


# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development


##Mongoid
gem 'mongoid', :git => 'https://github.com/mongoid/mongoid'
gem 'bson_ext'

#Twitter bootstrap
#gem 'twitter-bootstrap-rails' , github: "seyhunak/twitter-bootstrap-rails"
gem 'railsstrap'
gem 'less-rails'
gem 'datetimepicker-rails', :git => 'https://github.com/zpaulovics/datetimepicker-rails', branch: 'master', submodules: true

#Assets


#Heroku
gem 'rails_12factor', group: :production

#Localization
gem 'rails-i18n'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'devise-bootstrap-views'

#Forms
gem 'simple_form'
gem 'country_select'

##Pagination
gem 'kaminari'
gem 'kaminari-mongoid'

#Authentication
gem 'devise', :git => 'https://github.com/plataformatec/devise'
gem 'cancan'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

#Location/Geocoding
gem "geocoder", :git => 'https://github.com/alexreisner/geocoder' #git fix ruby-2.0.0 compatibility
gem 'gmaps-autocomplete-rails', :git => 'https://github.com/kristianmandrup/gmaps-autocomplete-rails'
gem 'jquery-ui-rails'


#Tests and fixtures
gem "rspec-rails", :group => [:development, :test]
gem "factory_girl_rails", :group => [:development, :test]
gem 'faker'
gem 'forgery'

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  #gem 'mongoid-rspec'
  gem 'email_spec'
  gem 'cucumber-rails', :require => false
  gem 'launchy'
end

group :development do
  #Chrome Rails panel extension
  gem 'meta_request'
end

#File uploads
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'rmagick'#, :require => 'rmagick'

#Exceptions and errors
# gem 'goalie'


# Use unicorn as the app server
gem 'unicorn'

#Rails 4 responders
gem 'responders'

#NewRelic
#gem 'newrelic_rpm', group: :production

#Facebook Koala
gem 'koala'
