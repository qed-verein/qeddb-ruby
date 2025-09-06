require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QeddbRuby
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_record.default_timezone = :utc
    config.time_zone = 'Europe/Berlin'

    default_url_options = {
      host: ENV['RAILS_HTTP_HOST'] || 'localhost',
      port: ENV['RAILS_HTTP_PORT'] || 3000,
      protocol: ENV['RAILS_HTTP_PROTOCOL'] || 'http'
    }
    config.action_controller.default_url_options = default_url_options
    config.action_mailer.default_url_options = default_url_options

    config.lock_event_after_end = 100.years
    config.max_deferred_payment = 2.years
    config.membership_fee	= 5
    config.external_surcharge	= 15
    config.admin_email_address  = ENV['QEDDB_ADMIN_EMAIL']       || 'admin@example.com'
    config.system_email_address = ENV['QEDDB_SYSTEM_EMAIL']      || 'qeddb@example.com'
    config.database_title       = ENV['QEDDB_TITLE']             || 'QED-Datenbank'
    config.mailinglist_domain   = ENV['QEDDB_EMAIL_DOMAIN']      || 'lists.example.com'
    config.banking_link         = ENV['QEDDB_BANKING_LINK']      || 'example.com/bankaccount'
    config.underage_formular    = ENV['QEDDB_UNDERAGE_FORMULAR'] || 'example.com/underageformular'
    config.iban 								= 'DE34762500000009344508'
    config.bic 									= 'BYLADEM1SFU'
    config.banking_name 				= 'QED-Verein'
    config.creditor_id 					= ENV['QEDDB_CREDITOR_ID'] || 'DE12QED1234EXAKT18'
    config.kassier_email_address = ENV['QEDDB_KASSIER_EMAIL'] || 'kassier@example.com'
    config.version_log_period = ENV['QEDDB_VERSION_LOG_PERIOD'] ? ENV['QEDDB_VERSION_LOG_PERIOD'].to_i : 3.years
  end
end
