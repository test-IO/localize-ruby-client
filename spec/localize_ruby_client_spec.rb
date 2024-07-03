# frozen_string_literal: true

RSpec.describe LocalizeRubyClient do # rubocop:disable Metrics/BlockLength
  before(:all) do
    described_class.configure do |config|
      config.app_id = "test_app_id"
      config.private_key = "test_private_key"
      config.root_path_to_save = "./spec/tmp/"
    end
  end

  let(:binary_zip) do
    File.open("spec/fixtures/zip.bin", "rb", &:read)
  end
  let(:path_to_file) { "./spec/fixtures/test_file.en.yml" }
  let(:project_uid) { 42 }

  after do
    directory = described_class.config.root_path_to_save
    FileUtils.rm_rf(directory) if directory.present? && File.directory?(directory)
  end

  it "has a version number" do
    expect(LocalizeRubyClient::VERSION).not_to be nil
  end

  describe ".update_translations" do
    context "successfull response" do
      it "return 200 if secrets are correct" do
        response = instance_double(HTTParty::Response, body: binary_zip)
        allow(subject.class).to receive(:get).and_return(response)
        allow(response).to receive(:success?).and_return(true)

        subject.update_translations(project_uid: project_uid)

        expect(File.exist?("./spec/tmp/en/simple_form.en.yml")).to be true
        expect(File.exist?("./spec/tmp/fr/simple_form.fr.yml")).to be true
        expect(subject.extracted_files_data[:created_files])
          .to match_array(["./spec/tmp/en/simple_form.en.yml", "./spec/tmp/fr/simple_form.fr.yml"])
      end
    end
  end

  describe ".translate" do
    it "return 200" do
      mock_response = instance_double(HTTParty::Response, code: 200)
      allow(subject.class).to receive(:post).and_return(mock_response)

      response = subject.translate(project_uid: project_uid)

      expect(response.code).to eq(200)
    end
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
        project_uid: project_uid,
        path_to_file: path_to_file,
        source_language_code: "en",
        conflict_mode: "replace"
      )

      expect(response.code).to eq(200)
      expect(response.body).to eq(body)
    end
  end
end
