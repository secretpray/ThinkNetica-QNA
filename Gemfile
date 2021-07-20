source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'slim-rails'
gem 'decent_exposure', '3.0.0'
gem 'simple_form'
gem 'devise'
gem 'pundit'
gem 'bootstrap', '~> 5.0.0.beta1'
gem 'mini_magick'
gem 'image_processing', '~> 1.2'
gem "google-cloud-storage", "~> 1.8", require: false
gem 'htmlrender'
gem 'gon'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'activerecord-session_store'
gem 'omniauth-rails_csrf_protection'
gem 'aws-sdk-s3', require: false
gem 'active_model_serializers', '~> 0.10.2'
gem 'oj'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem "doorkeeper", "~> 5.5"
gem 'mysql2', '~> 0.4',    :platform => :ruby
gem 'thinking-sphinx', '~> 5.2'
gem 'mini_racer'
gem 'spring'

group :development, :test do
  gem 'pry', '~> 0.13.1'
  gem 'pry-byebug'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
  gem 'capybara-email'
  gem 'database_cleaner'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  # gem 'capistrano-sidekiq', require: false
  gem "capistrano-sidekiq", git: "https://github.com/rwojnarowski/capistrano-sidekiq.git"
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'rails-controller-testing'
  gem 'launchy', '~> 2.4', '>= 2.4.3'
  # It allows you to run your Capybara tests in the Chrome browser via CDP (no selenium or chromedriver needed)
  gem 'apparition'
end

gem "letter_opener", group: :development
# -> gem "letter_opener_web", "~> 1.3", ">= 1.3.4"
