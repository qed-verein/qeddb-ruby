require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
	# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
	fixtures :all

	# Add more helper methods to be used by all tests here...



	# Wir müssen uns einloggen, damit die Tests funktionieren
	#setup { post login_url, params: { session: {account_name: 'testuser', password: 'testuser'} } }
end
