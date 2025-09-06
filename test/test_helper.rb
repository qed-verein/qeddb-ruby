require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Wir müssen uns einloggen, damit die Tests funktionieren
    # setup { post login_url, params: { session: {account_name: 'testuser', password: 'testuser'} } }
  end
end
