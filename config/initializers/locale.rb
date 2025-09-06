# frozen_string_literal: true

Rails.application.config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
Rails.application.config.i18n.available_locales = %i[de en]
Rails.application.config.i18n.default_locale = :de
