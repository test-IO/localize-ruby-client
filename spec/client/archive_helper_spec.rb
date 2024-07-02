# frozen_string_literal: true

require "client/archive_helper"
require "client/config"

RSpec.describe Client::ArchiveHelper do # rubocop:disable Metrics/BlockLength
  let(:dummy_class) do
    Class.new do
      include Client::ArchiveHelper
    end
  end

  let(:instance) { dummy_class.new }
  let(:config) { Client::Config.new }
  let(:extracted_files_data) { { created_files: [] } }

  before do
    allow(LocalizeRubyClient).to receive(:config).and_return(config)
    config.root_path_to_save = Dir.mktmpdir
  end

  after do
    FileUtils.remove_entry(config.root_path_to_save)
  end

  describe "#replace_translation_files" do
    it "extracts files from the zip data" do
      zip_data = Zip::OutputStream.write_buffer do |zip|
        zip.put_next_entry("test_file.txt")
        zip.write "This is a test file"
      end.string

      instance.replace_translation_files(zip_data, extracted_files_data)

      expect(extracted_files_data[:created_files]).to include(a_string_ending_with("test_file.txt"))
      expect(File).to exist(File.join(config.root_path_to_save, "test_file.txt"))
      expect(File.read(File.join(config.root_path_to_save, "test_file.txt"))).to eq("This is a test file")
    end
  end

  describe "#extract_entries" do
    it "creates directories and extracts entries" do
      Tempfile.open(["test", ".zip"]) do |tempfile|
        Zip::OutputStream.open(tempfile) do |zip|
          zip.put_next_entry("dir/test_file.txt")
          zip.write "This is a test file"
        end

        tempfile.rewind
        instance.extract_entries(tempfile, extracted_files_data)

        full_path = File.join(config.root_path_to_save, "dir", "test_file.txt")
        expect(extracted_files_data[:created_files]).to include(full_path)
        expect(File).to exist(full_path)
        expect(File.read(full_path)).to eq("This is a test file")
      end
    end
  end
end
