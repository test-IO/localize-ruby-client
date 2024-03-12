# frozen_string_literal: true

require_relative "client/version"

require 'openssl'
require 'jwt'
require 'httparty'
require 'zip'

class Client
  APP_ID            = ENV['APP_ID']
  PRIVATE_KEY       = ENV['PRIVATE_KEY']
  PROJECT_UID       = ENV['PROJECT_UID']
  ROOT_PATH_TO_SAVE = ENV['ROOT_PATH_TO_SAVE']

  include HTTParty
  base_uri "https://localize.cirro.io/api/v2/continuous_projects/#{PROJECT_UID}"

  def initialize
    self.class.headers 'Authorization' => "jwt #{jwt_token}"
  end

  def update_translations # downloads all translated files
    response = self.class.get('/target_files')
    replace_translation_files(response.body)
  end

  def upload_file(file:, source_language_code:, conflict_mode:)
    payload = {
      uid: PROJECT_UID,
      import: {
        file: file,
        source_language_code: source_language_code,
        conflict_mode: conflict_mode
      }
    }
    self.class.post('/imports', body: payload.to_param)
  end

  def translate
    self.class.post('/translation_requests')
  end

  private

  def jwt_token
    payload = {
      exp: 10.minutes.from_now.to_i,
      iss: APP_ID
    }

    JWT.encode(payload, PRIVATE_KEY, 'HS256')
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
      path_to_save = ROOT_PATH_TO_SAVE + entry_file.name

      # option { true } allows to replace file if he already exists
      entry_file.extract(path_to_save) { true }
    end
  end
end
