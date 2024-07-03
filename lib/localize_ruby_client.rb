# frozen_string_literal: true

require "httparty"
require "jwt"
require "active_support"
require "active_support/time"
require "zip"
require "tempfile"

require_relative "client/configuration_helper"
require_relative "client/version"

if defined?(Rails)
  require "rails/railtie"
  require_relative "client/railtie"
end

# The LocalizeRubyClient class serves as the main class of the LocalizeRubyClient gem.
# It contains the core logic for interacting with the Localize API
# This class utilizes HTTParty to perform HTTP requests to the Localize API,
# providing methods to update translations, request translations, and upload files.
class LocalizeRubyClient
  include HTTParty
  include Client::ConfigurationHelper

  attr_accessor :extracted_files_data

  def initialize
    @extracted_files_data = { created_files: [] }

    self.class.headers "Authorization" => "jwt #{jwt_token}"
    self.class.base_uri "#{LocalizeRubyClient.config.site}/#{LocalizeRubyClient.config.api_version}"
  end

  # Fetches and updates translation files for a given project.
  # Downloads the target files from the Localize API and replaces the local files with the downloaded content.
  #
  # @param project_uid [String] the unique identifier for the project
  # @return [HTTParty::Response] the response from the Localize API
  def update_translations(project_uid:)
    response = self.class.get("/continuous_projects/#{project_uid}/target_files")
    replace_translation_files(response.body) if response.success?
    response
  end

  # Requests a translation for the given project from the Localize API.
  #
  # @param project_uid [String] the unique identifier for the project
  # @return [HTTParty::Response] the response from the Localize API
  def translate(project_uid:)
    self.class.post("/continuous_projects/#{project_uid}/translation_requests")
  end

  # Uploads a file to the Localize API for a specified project.
  #
  # @param project_uid [String] the unique identifier for the project
  # @param path_to_file [String] the path to the file to be uploaded
  # @param source_language_code [String] the language code of the source file
  # @param conflict_mode [String] the conflict resolution mode to use (e.g., "replace")
  # @return [HTTParty::Response] the response from the Localize API
  # @raise [ArgumentError] if the file does not exist at the specified path
  def upload_file(project_uid:, path_to_file:, source_language_code:, conflict_mode:) # rubocop:disable Metrics/MethodLength
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

  private

  def jwt_token
    payload = {
      exp: 10.minutes.from_now.to_i,
      iss: LocalizeRubyClient.config.app_id
    }

    JWT.encode(payload, LocalizeRubyClient.config.private_key, "HS256")
  end

  def replace_translation_files(data)
    temp_file = Tempfile.new
    temp_file.binmode
    temp_file.write(data)
    temp_file.rewind
    extract_entries(temp_file)
    temp_file.close
    temp_file.unlink
  end

  def extract_entries(temp_file)
    Zip::File.open(temp_file).each do |entry_file|
      full_path_to_save = File.join(LocalizeRubyClient.config.root_path_to_save, entry_file.name)
      directory_path = File.dirname(full_path_to_save)
      FileUtils.mkdir_p(directory_path) unless File.directory?(directory_path)

      # option { true } allows to replace file if it already exists
      entry_file.extract(full_path_to_save) { true }
      extracted_files_data[:created_files].push(full_path_to_save)
    end
  end
end
