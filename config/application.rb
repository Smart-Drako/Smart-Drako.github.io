require_relative 'boot'
require 'rails/all'
require 'roo'
require "browser"
require "base64"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pideloencasa
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = "America/Tijuana"
    config.active_record.default_timezone = :local

    config.to_prepare do
      # Configure single controller layout
      Devise::RegistrationsController.layout "registro"
      Devise::SessionsController.layout "login"
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

