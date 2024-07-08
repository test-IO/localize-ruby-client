# frozen_string_literal: true

require_relative "config"

module Client
  # The ConfigurationHelper module provides a class-level interface for configuring
  # the Client gem. It allows setting configuration options such as app_id,
  # private_key, locales_dir_path, site, and api_version. It also validates the
  # configuration to ensure required values are present.
  module ConfigurationHelper
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods # rubocop:disable Style/Documentation
      attr_accessor :config

      def configure
        self.config ||= Config.new
        yield(config)
        self.config.validate!
      end
    end
  end
end
