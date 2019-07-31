# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'socket'
require 'ipaddr'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BlijblijblijCom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      # Don't generate assets for Sprockets
      g.assets = nil
      # Don't generate tests and helpers (for this tutorial)
      g.test_framework = nil
      g.helper = nil
    end
    if ENV['DOCKERIZED'] == 'true'
      Socket.ip_address_list.each do |addrinfo|
        next unless addrinfo.ipv4?
        next if addrinfo.ip_address == '127.0.0.1' # Already whitelisted

        ip = IPAddr.new(addrinfo.ip_address).mask(24)

        Logger.new(STDOUT).info "Adding #{ip.inspect} to config.web_console.whitelisted_ips"

        config.web_console.whitelisted_ips << ip
      end
    end
  end
end
