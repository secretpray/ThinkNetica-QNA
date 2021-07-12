# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  # DatabaseCleaner settings
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
    # Index data when running an acceptance spec.
    ThinkingSphinx::Test.index
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
