# frozen_string_literal: true

require 'client'
require 'active_support/time'
require 'dotenv'
Dotenv.load('./.env.test')

namespace :client do
  desc 'Upload file to Localize API'
  task :upload_file do
    ARGV.each { |a| task a.to_sym do ; end }

    path_to_file = ARGV[1].to_s
    source_language_code = ARGV[2].to_s
    conflict_mode = ARGV[3].to_s

    puts "path_to_file: #{path_to_file}"
    puts "source_language_code: #{source_language_code}"
    puts "conflict_mode: #{conflict_mode}"

    result = Client.new.upload_file(
      path_to_file: path_to_file,
      source_language_code: source_language_code,
      conflict_mode: conflict_mode
    )
    puts "Upload file: #{result.message}"
    puts "Upload file: #{result}"
  end

  desc 'Translate uploaded file by Localize API'
  task :translate do
    result = Client.new.translate
    puts "Translate: #{result.message}"
    puts "Translate: #{result}"
  end

  desc 'Download and update all files from Localize API'
  task :update_translations do
    client = Client.new
    result = client.update_translations
    puts "Update translations: #{result.message}"
    puts client.extracted_files_data
  end

  desc 'Upload file to Localize API, translate and download from there'
  task :upload_and_translate_file do
    ARGV.each { |a| task a.to_sym do ; end }

    Rake::Task["client:upload_file"].invoke(ARGV[1], ARGV[2], ARGV[3])
    sleep 1
    Rake::Task["client:translate"].invoke
    sleep 1
    Rake::Task["client:update_translations"].invoke
  end
end

