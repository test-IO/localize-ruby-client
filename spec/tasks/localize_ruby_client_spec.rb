# frozen_string_literal: true

require "rake"

RSpec.describe "localize_ruby_client" do # rubocop:disable Metrics/BlockLength
  before(:all) do
    Rake.application.rake_require("tasks/localize_ruby_client")
    Rake::Task.define_task(:environment)

    LocalizeRubyClient.configure do |config|
      config.app_id = "test_app_id"
      config.private_key = "test_private_key"
      config.project_uid = "123abc"
    end
  end

  describe "localize_ruby_client:upload_files" do
    let(:rake_task) { Rake::Task["localize_ruby_client:upload_files"] }
    let(:expected_output) do
      "'#{LocalizeRubyClient.config.locales_dir_path}/test_file.en.yml': success\n"\
      "Successfully processed 1 of 1 files\n"
    end

    let(:expected_upload_params) do
      {
        path_to_file: "#{LocalizeRubyClient.config.locales_dir_path}/test_file.en.yml",
        source_language_code: "en",
        conflict_mode: "replace"
      }
    end

    it "uploads a file with the correct arguments" do
      expect_any_instance_of(LocalizeRubyClient).to receive(:upload_file)
        .with(expected_upload_params)
        .and_return(OpenStruct.new(message: "success", success?: true))

      expect do
        rake_task.invoke
      end.to output(expected_output).to_stdout
    end
  end

  describe "localize_ruby_client:translate" do
    let(:rake_task) { Rake::Task["localize_ruby_client:translate"] }
    let(:expected_output) do
      "Translate project 123abc\nTranslate: success\n"
    end

    it "translates a project with the correct arguments" do
      expect_any_instance_of(LocalizeRubyClient).to receive(:translate)
        .and_return(OpenStruct.new(message: "success", success?: true))

      expect do
        rake_task.invoke
      end.to output(expected_output).to_stdout
    end
  end

  describe "localize_ruby_client:update_translations" do
    let(:rake_task) { Rake::Task["localize_ruby_client:update_translations"] }
    let(:expected_output) do
      "Updating translations for project 123abc\nUpdate translations: success\n"
    end

    it "updates translations for the project with the correct arguments" do
      expect_any_instance_of(LocalizeRubyClient).to receive(:update_translations)
        .and_return(OpenStruct.new(message: "success", success?: true))

      expect do
        rake_task.invoke
      end.to output(expected_output).to_stdout
    end
  end
end
