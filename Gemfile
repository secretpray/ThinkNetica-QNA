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

group :development, :test do
  gem 'pry', '~> 0.13.1'
  gem 'pry-byebug'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
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

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
