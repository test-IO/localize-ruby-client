# frozen_string_literal: true

RSpec.describe LocalizeRubyClient do # rubocop:disable Metrics/BlockLength
  let(:binary_zip) { File.open("spec/fixtures/zip.bin", "rb", &:read) }
  let(:path_to_file) { "#{described_class.config.locales_dir_path}/test_file.en.yml" }

  before do
    described_class.configure do |config|
      config.app_id = "test_app_id"
      config.private_key = "test_private_key"
      config.project_uid = "test_project_id"
    end

    # Create a copy of the directory
    directory = described_class.config.locales_dir_path
    FileUtils.cp_r(directory, "#{directory}_tmp")

    # Set TMP copy as the save root directory
    described_class.config.locales_dir_path = "#{directory}_tmp"
  end

  after do
    # Here remove TMP copy of the directory
    directory = described_class.config.locales_dir_path
    FileUtils.rm_rf(directory) if directory.present? && File.directory?(directory)

    # Set root path to original
    described_class.config.locales_dir_path = Rails.root.join("config", "locales").to_s
  end

  it "has a version number" do
    expect(LocalizeRubyClient::VERSION).not_to be nil
  end

  describe ".upload_file" do
    it "return 200 if params are correct" do
      body = {
        "import": {
          "id": 123,
          "conflict_mode": "replace",
          "target_file": {
            "key": "-your-file-name-.yml",
            "target_language": "en"
          }
        }
      }
      mocked_response = instance_double(HTTParty::Response, body: body, code: 200)
      allow(subject.class).to receive(:post).and_return(mocked_response)

      response = subject.upload_file(
        path_to_file: path_to_file,
        source_language_code: "en",
        conflict_mode: "replace"
      )

      expect(response.code).to eq(200)
      expect(response.body).to eq(body)
    end
  end

  describe ".update_translations" do
    context "successfull response" do
      it "return 200 if secrets are correct" do
        response = instance_double(HTTParty::Response, body: binary_zip)
        allow(subject.class).to receive(:get).and_return(response)
        allow(response).to receive(:success?).and_return(true)

        subject.update_translations

        expect(File.exist?("#{described_class.config.locales_dir_path}/simple_form.en.yml")).to be true
        expect(File.exist?("#{described_class.config.locales_dir_path}/simple_form.fr.yml")).to be true
      end
    end
  end
end
