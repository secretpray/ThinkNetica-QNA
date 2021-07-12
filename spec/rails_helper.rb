# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'capybara/rspec'
require 'selenium-webdriver'
require "pundit/rspec"
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
Dir[Rails.root.join("spec/models/concerns/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("spec/controllers/concerns/**/*.rb")].each {|f| require f}
# Dir[Rails.root.join("spec/support/shared_examples/**/*.rb")].each {|f| require f}

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include OmniauthHelper # OmniAuth
  config.include ApiHelpers, type: :request

  # Capybara.javascript_driver = :selenium_chrome
  Capybara.javascript_driver = :selenium_chrome_headless

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # config.use_transactional_fixtures = true
  # Search
  config.use_transactional_fixtures = false

  config.before(:each) do
    # Default to transaction strategy for all specs
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  # OmniAuth
  OmniAuth.config.test_mode = true
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
  config.after(:all) do
    FileUtils.rm_rf "#{Rails.root}/tmp/storage"
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
