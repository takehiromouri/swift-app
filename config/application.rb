require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SwiftApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # set default to japanese
    config.i18n.default_locale = :ja

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs false
      g.helper_specs false
      g.stylesheets = false
      g.javascripts = false
      g.helper = false
    end

    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.autoload_paths += %W(#{config.root}/app/services)

    # config.active_job.queue_adapter = :sidekiq

    config.encoding = "utf-8"
  end

end
