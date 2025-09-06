# frozen_string_literal: true

# config/initializers/scenic.rb

Scenic.configure do |config|
  config.database = Scenic::Adapters::Sqlite.new
end
