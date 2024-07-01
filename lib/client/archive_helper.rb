require 'zip'
require 'tempfile'

module Client
  module ArchiveHelper
    def replace_translation_files(data, extracted_files_data)
      temp_file = Tempfile.new
      temp_file.binmode
      temp_file.write(data)
      temp_file.rewind
      extract_entries(temp_file, extracted_files_data)
      temp_file.close
      temp_file.unlink
    end

    def extract_entries(temp_file, extracted_files_data)
      Zip::File.open(temp_file).each do |entry_file|
        full_path_to_save = LocalizeRubyClient.config.root_path_to_save + entry_file.name
        directory_path = File.dirname(full_path_to_save)
        FileUtils.mkdir_p(directory_path) unless File.directory?(directory_path)

        # option { true } allows to replace file if it already exists
        entry_file.extract(full_path_to_save) { true }
        extracted_files_data[:created_files].push(full_path_to_save)
      end
    end
  end
end
