# frozen_string_literal: true

require 'i18n'

I18n.load_path += Dir[File.expand_path(File.join(__dir__, 'locales', '*.yml'))]
I18n.default_locale = :ru
I18n.available_locales = %i[ru]
