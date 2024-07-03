# frozen_string_literal: true

module Client
  # The Config class holds configuration settings for the LocalizeRubyClient.
  # It provides attributes for app_id, private_key, root_path_to_save, site, and api_version.
  # It also includes a method to validate these configurations to ensure they are properly set.
  class Config
    attr_accessor :app_id, :private_key, :root_path_to_save, :site, :api_version

    def initialize
      @app_id = nil
      @private_key = nil
      @root_path_to_save = nil
      @site = "https://localize.cirro.io/api"
      @api_version = "v2"
    end

    def validate!
      credentials = {
        app_id: @app_id,
        private_key: @private_key,
        root_path_to_save: @root_path_to_save
      }

      messages = credentials.map do |variable_name, value|
        "Error: uninitialized configuration #{variable_name}" if value.nil? || value.strip.empty?
      end.compact

      raise NameError, messages.join(", ") if messages.present?
    end
  end
end
