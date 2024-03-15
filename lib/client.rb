# frozen_string_literal: true

require_relative 'client/version'
require 'active_support'
require 'openssl'
require 'jwt'
require 'httparty'
require 'zip'

class Client
  include HTTParty
  attr_reader :app_id,
              :private_key,
              :project_uid,
              :root_path_to_save,
              :extracted_files_data

  def initialize
    @app_id            = ENV['APP_ID']
    @private_key       = ENV['PRIVATE_KEY']
    @project_uid       = ENV['PROJECT_UID']
    @root_path_to_save = ENV['ROOT_PATH_TO_SAVE']
    @extracted_files_data = { created_files: [] }

    self.class.headers 'Authorization' => "jwt #{jwt_token}"
    self.class.base_uri "https://localize.cirro.io/api/v2/continuous_projects/#{project_uid}"
  end

  def update_translations
    validate_credentials
    response = self.class.get('/target_files')
    replace_translation_files(response.body) if response.success?
    response
  end

  def translate
    validate_credentials
    self.class.post('/translation_requests')
  end

  def upload_file(path_to_file:, source_language_code:, conflict_mode:)
    validate_credentials
    unless File.exist?(path_to_file)
      raise ArgumentError, 'Error: file not found'
    end

    binary_data = File.open(path_to_file, 'rb') { |io| io.read }
    payload = {
      uid: project_uid,
      import: {
        file: binary_data,
        source_language_code: source_language_code,
        conflict_mode: conflict_mode
      }
    }

    self.class.post('/imports', body: payload.to_param)
  end

  private

  def jwt_token
    payload = {
      exp: 10.minutes.from_now.to_i,
      iss: app_id
    }

    JWT.encode(payload, private_key, 'HS256')
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
      full_path_to_save = root_path_to_save + entry_file.name
      directory_path = File.dirname(full_path_to_save)
      FileUtils.mkdir_p(directory_path) unless File.directory?(directory_path)

      # option { true } allows to replace file if he already exists
      entry_file.extract(full_path_to_save) { true }
      extracted_files_data[:created_files].push(full_path_to_save)
    end
  end

  def validate_credentials
    credentials = {
      app_id: app_id,
      private_key: private_key,
      project_uid: project_uid,
      root_path_to_save: root_path_to_save
    }

    messages = credentials.map do |variable_name, variable|
      "Error: uninitialized constant #{variable_name.upcase} in .env" if variable.blank?
    end.compact

    raise NameError, messages.join(', ') if messages.present?
  end
end
