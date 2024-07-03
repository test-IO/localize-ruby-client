# frozen_string_literal: true

require "localize_ruby_client"
require "active_support/time"

namespace :localize_ruby_client do # rubocop:disable Metrics/BlockLength
  desc "Upload file to Localize API"
  task :upload_file, %i[project_uid path_to_file source_language_code conflict_mode] => :environment do |_t, args|
    args.with_defaults(conflict_mode: "replace")

    puts "Uploading file '#{args[:path_to_file]}' to project '#{args[:project_uid]}'" \
         " with source language '#{args[:source_language_code]}' and conflict mode '#{args[:conflict_mode]}'"

    result = LocalizeRubyClient.new.upload_file(
      project_uid: args[:project_uid],
      path_to_file: args[:path_to_file],
      source_language_code: args[:source_language_code],
      conflict_mode: args[:conflict_mode]
    )

    puts "Upload file: #{result.message}"
    puts "Upload file: #{result}"
  end

  desc "Translate uploaded file by Localize API"
  task :translate, [:project_uid] => :environment do |_t, args|
    puts "Translate project #{args[:project_uid]}"

    result = LocalizeRubyClient.new.translate(project_uid: args[:project_uid])

    puts "Translate: #{result.message}"
    puts "Translate: #{result}"
  end

  desc "Download and update all files from Localize API"
  task :update_translations, [:project_uid] => :environment do |_t, args|
    puts "Updating translations for project #{args[:project_uid]}"
    client = LocalizeRubyClient.new
    result = client.update_translations(project_uid: args[:project_uid])
    puts "Update translations: #{result.message}"
    puts "Update translations: #{client.extracted_files_data}"
  end

  desc "Upload file to Localize API, translate and download from there"
  task :upload_and_translate_file,
       %i[project_uid path_to_file source_language_code conflict_mode] => :environment do |_t, args|
    Rake::Task["localize_ruby_client:upload_file"].invoke(args[:project_uid], args[:path_to_file],
                                                          args[:source_language_code], args[:conflict_mode])
    Rake::Task["localize_ruby_client:translate"].invoke(args[:project_uid])
    Rake::Task["localize_ruby_client:update_translations"].invoke(args[:project_uid])
  end
end
