# frozen_string_literal: true

require "httparty"

require_relative "client/configuration_helper"
require_relative "client/version"
require_relative "client/jwt_helper"
require_relative "client/archive_helper"

if defined?(Rails)
  require "rails/railtie"
  require_relative "client/railtie"
end

class LocalizeRubyClient
  include HTTParty
  include Client::JwtHelper
  include Client::ArchiveHelper
  include Client::ConfigurationHelper

  attr_accessor :extracted_files_data

  def initialize
    @extracted_files_data = { created_files: [] }

    self.class.headers "Authorization" => "jwt #{jwt_token}"
    self.class.base_uri "#{LocalizeRubyClient.config.site}/#{LocalizeRubyClient.config.api_version}"
  end

  def update_translations(project_uid:)
    response = self.class.get("/continuous_projects/#{project_uid}/target_files")
    replace_translation_files(response.body, extracted_files_data) if response.success?
    response
  end

  def translate(project_uid:)
    self.class.post("/continuous_projects/#{project_uid}/translation_requests")
  end

  def upload_file(project_uid:, path_to_file:, source_language_code:, conflict_mode:)
    raise ArgumentError, "Error: file not found" unless File.exist?(path_to_file)

    binary_data = File.open(path_to_file, "rb", &:read)
    payload = {
      uid: project_uid,
      import: {
        file: binary_data,
        source_language_code: source_language_code,
        conflict_mode: conflict_mode
      }
    }

    self.class.post("/continuous_projects/#{project_uid}/imports", body: payload.to_param)
  end
end
