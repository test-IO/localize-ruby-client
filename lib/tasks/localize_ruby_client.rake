# frozen_string_literal: true

require "localize_ruby_client"
require "active_support/time"

namespace :localize_ruby_client do # rubocop:disable Metrics/BlockLength
  desc "Upload file to Localize API"
  task :upload_files, [:conflict_mode] => :environment do |_t, args|
    args.with_defaults(conflict_mode: "replace")

    processed_files = []
    folder_path = LocalizeRubyClient.config.locales_dir_path

    locale_files = Dir.glob("#{folder_path}/**/*").select { |file| File.file?(file) }
    locale_files.each do |locale_file_path|
      source_language_code = File.basename(locale_file_path)[/(?:\w+\.)?([a-z]{2}(?:-[a-z]{2})?)\.yml$/i, 1]
      result = LocalizeRubyClient.new.upload_file(
        path_to_file: locale_file_path,
        source_language_code: source_language_code,
        conflict_mode: args[:conflict_mode]
      )

      puts "'#{locale_file_path}': #{result.message}"

      processed_files << locale_file_path if result.success?
    end

    puts "Successfully processed #{processed_files.count} of #{locale_files.count} files"
  end

  desc "Translate uploaded file by Localize API"
  task translate: :environment do
    puts "Translate project #{LocalizeRubyClient.config.project_uid}"

    result = LocalizeRubyClient.new.translate

    puts "Translate: #{result.message}"
  end

  desc "Download and update all files from Localize API"
  task update_translations: :environment do
    puts "Updating translations for project #{LocalizeRubyClient.config.project_uid}"
    result = LocalizeRubyClient.new.update_translations
    puts "Update translations: #{result.message}"
  end
end
