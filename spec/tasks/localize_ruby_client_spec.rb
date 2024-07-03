# frozen_string_literal: true

require "rake"

RSpec.describe "localize_ruby_client" do # rubocop:disable Metrics/BlockLength
  before(:all) do
    Rake.application.rake_require("tasks/localize_ruby_client")
    Rake::Task.define_task(:localize_ruby_client)
  end

  after { rake_task.reenable }

  describe "localize_ruby_client:upload_file" do
    let(:rake_task) { Rake::Task["localize_ruby_client:upload_file"] }
    let(:expected_output) do
      "Uploading file 'test.yml' to project '123' with source language 'en' and conflict mode 'replace'\n"\
      "Upload file: success\nUpload file: #<OpenStruct message=\"success\">\n"
    end

    it "uploads a file with the correct arguments" do
      expect(LocalizeRubyClient).to receive(:new).and_return(double(upload_file: OpenStruct.new(message: "success")))
      expect do
        rake_task.invoke("123", "test.yml", "en", "replace")
      end.to output(expected_output).to_stdout
    end
  end

  describe "localize_ruby_client:translate" do
    let(:rake_task) { Rake::Task["localize_ruby_client:translate"] }
    let(:expected_output) do
      "Translate project 123\nTranslate: success\nTranslate: #<OpenStruct message=\"success\">\n"
    end

    it "translates a project with the correct arguments" do
      expect(LocalizeRubyClient).to receive(:new).and_return(double(translate: OpenStruct.new(message: "success")))
      expect do
        rake_task.invoke("123")
      end.to output(expected_output).to_stdout
    end
  end

  describe "localize_ruby_client:update_translations" do
    let(:rake_task) { Rake::Task["localize_ruby_client:update_translations"] }
    let(:expected_output) do
      "Updating translations for project 123\nUpdate translations: success\nUpdate translations: {:created_files=>[]}\n"
    end

    let(:client_double) do
      double(update_translations: OpenStruct.new(message: "success"), extracted_files_data: { created_files: [] })
    end

    it "updates translations for the project with the correct arguments" do
      expect(LocalizeRubyClient).to receive(:new).and_return(client_double)
      expect do
        rake_task.invoke("123")
      end.to output(expected_output).to_stdout
    end
  end

  describe "localize_ruby_client:upload_and_translate_file" do
    let(:rake_task) { Rake::Task["localize_ruby_client:upload_and_translate_file"] }

    let(:client_double) do
      double(update_translations: OpenStruct.new(message: "success"), extracted_files_data: { created_files: [] })
    end

    let(:upload_file_expected_output) do
      "Uploading file 'test.yml' to project '123' with source language 'en' and conflict mode 'replace'"
    end
    let(:translate_expected_output) { "Translate project 123" }
    let(:update_translation_expected_output) { "Updating translations for project 123" }

    it "runs the composite task with the correct arguments" do
      expect(LocalizeRubyClient).to receive(:new).and_return(double(upload_file: OpenStruct.new(message: "success")))
      expect(LocalizeRubyClient).to receive(:new).and_return(double(translate: OpenStruct.new(message: "success")))
      expect(LocalizeRubyClient).to receive(:new).and_return(client_double)

      expect do
        rake_task.invoke("123", "test.yml", "en", "replace")
      end.to output(
        /#{upload_file_expected_output}.*#{translate_expected_output}.*#{update_translation_expected_output}/m
      ).to_stdout
    end
  end
end
