# frozen_string_literal: true

require "active_support/time"


RSpec.describe Client do
  let(:binary_zip) {
    "PK\x03\x04\x14\x00\x00\x00\b\x00\xD7rmXM\xD0\xB5l\x85\x00\x00\x00\xBD\x00\x00\x00\x15\x00\x00\x00en/simple_form.en.yml=\x8DA\x0E\xC2 \x10E\xF7\x9Cb\xD2\r\x89I/\xC0!\x8C[W\x84\xDA\x8F\x12\x81\xA9\x03m\xF5\xF6R\xAB\xAE&\xEF\xE5\xFF?}\xDF+d\xA3\x88JHS\x84\xF5,iC\"\xFDB\xD1\x86\xF4\xB9\x9D]d\xDE\xF8\xC8;\n\x1Es\x10\x8C{\x9A\xA8\xE2Y\xCD\xDF~err7\xD4\x1D\xBA\x0FC\x84\xC5f\xAE\xC1\x87\x8B\xAB\x81\xF3\xAF<\xC2\xBB9V\x9BP\x8A\xBB\xA2\xBD9E\xB8\x82\xB6\xB7\x04\xACTo\xA0Ix\x88H\x85\x06D^\x8DVoPK\x03\x04\x14\x00\x00\x00\b\x00\xD7rmX\xC33<\x96\x8E\x00\x00\x00\xC4\x00\x00\x00\x15\x00\x00\x00fr/simple_form.fr.yml5\xCB\xC1\r\xC20\x10D\xD1{\xAA\x18\xE5b\t\xC9\r\xB8\b\xB8q\x8DL\xB2F+loX\xDBR\xA0\"\xFA\xA01B\x02\xC77\xFAc\xAD\xED\x82\xBA\x0E(\x9C\xE6HC\x10M_\x02\xE6A\xC58\x9C\x1A\xEF\xCC\xB2\xEA(y\x93\xD2\xBD\xB1\xD2\xB4\xA7@\xA5\xA5\xBA}-\xBF)y\xBD9\xF4\x87~3\xA9\x8A\x0EY*\a\x1E}e\xC9\xFF\xEBD\xC1\xB7X\x87D\xA5\xF8+9\x9835\x8E\x91\x9E\xA0\xC5'\xCE\xA4\x88T0\xAB\\\xE2\xFB\xB5f\x18\xD9Nk-\xAD\xC0\x99\xEE\x03PK\x01\x024\x03\x14\x00\x00\x00\b\x00\xD7rmXM\xD0\xB5l\x85\x00\x00\x00\xBD\x00\x00\x00\x15\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\xA4\x81\x00\x00\x00\x00en/simple_form.en.ymlPK\x01\x024\x03\x14\x00\x00\x00\b\x00\xD7rmX\xC33<\x96\x8E\x00\x00\x00\xC4\x00\x00\x00\x15\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\xA4\x81\xB8\x00\x00\x00fr/simple_form.fr.ymlPK\x05\x06\x00\x00\x00\x00\x02\x00\x02\x00\x86\x00\x00\x00y\x01\x00\x00\x00\x00"
   }
  let(:path_to_file) { './spec/support/test_file.en.yml' }

  after do
    directory = ENV['ROOT_PATH_TO_SAVE']
    if directory.present? && File.directory?(directory)
      FileUtils.rm_rf(directory)
    end
  end

  it "has a version number" do
    expect(Client::VERSION).not_to be nil
  end

  describe ".update_translations" do
    context "successfull response" do
      it "return 200 if secrets are correct" do
        response = instance_double(HTTParty::Response, body: binary_zip)
        allow(subject.class).to receive(:get).and_return(response)
        allow(response).to receive(:success?).and_return(true)

        subject.update_translations

        expect(File.exist?("./spec/tmp/en/simple_form.en.yml")).to be true
        expect(File.exist?("./spec/tmp/fr/simple_form.fr.yml")).to be true
        expect(subject.extracted_files_data[:created_files])
          .to match_array(["./spec/tmp/en/simple_form.en.yml", "./spec/tmp/fr/simple_form.fr.yml"])
      end
    end

    context "return errors" do
      it "return 401 if secrets aren't correct" do
        result = subject.update_translations

        expect(result.code).to eq(401)
      end

      it "raise NameError if APP_ID is uninitialized in .env file" do
        allow(subject).to receive(:app_id).and_return(nil)

        expect { subject.update_translations }.to raise_error(
          NameError, "Error: uninitialized constant APP_ID in .env"
        )
      end

      it "raise NameError if PRIVATE_KEY is uninitialized in .env file" do
        allow(subject).to receive(:private_key).and_return(nil)

        expect { subject.update_translations }.to raise_error(
          NameError, "Error: uninitialized constant PRIVATE_KEY in .env"
        )
      end

      it "raise NameError if PROJECT_UID is uninitialized in .env file" do
        allow(subject).to receive(:project_uid).and_return(nil)

        expect { subject.update_translations }.to raise_error(
          NameError, "Error: uninitialized constant PROJECT_UID in .env"
        )
      end

      it "raise NameError if ROOT_PATH_TO_SAVE is uninitialized in .env file" do
        allow(subject).to receive(:root_path_to_save).and_return(nil)

        expect { subject.update_translations }.to raise_error(
          NameError, "Error: uninitialized constant ROOT_PATH_TO_SAVE in .env"
        )
      end

      it "raise NameError if all constants are uninitialized in .env file" do
        allow(subject).to receive(:app_id ).and_return(nil)
        allow(subject).to receive(:project_uid, ).and_return(nil)
        allow(subject).to receive(:private_key).and_return(nil)
        allow(subject).to receive(:root_path_to_save).and_return(nil)
        error_message = "Error: uninitialized constant APP_ID in .env, "\
                        "Error: uninitialized constant PRIVATE_KEY in .env, "\
                        "Error: uninitialized constant PROJECT_UID in .env, "\
                        "Error: uninitialized constant ROOT_PATH_TO_SAVE in .env"

        expect { subject.update_translations }
          .to raise_error(NameError, error_message)
      end
    end
  end

  describe ".translate" do
    it "return 200" do
      mock_response = instance_double(HTTParty::Response, code: 200)
      allow(subject.class).to receive(:post).and_return(mock_response)

      response = subject.translate

      expect(response.code).to eq(200)
    end

    context "return errors" do
      it "raise NameError if APP_ID is uninitialized in .env file" do
        allow(subject).to receive(:app_id).and_return(nil)

        expect {
          subject.translate
        }.to raise_error(
          NameError, "Error: uninitialized constant APP_ID in .env"
        )
      end

      it "raise NameError if PRIVATE_KEY is uninitialized in .env file" do
        allow(subject).to receive(:private_key).and_return(nil)

        expect {
          subject.translate
        }.to raise_error(
          NameError, "Error: uninitialized constant PRIVATE_KEY in .env"
        )
      end

      it "raise NameError if PROJECT_UID is uninitialized in .env file" do
        allow(subject).to receive(:project_uid).and_return(nil)

        expect {
          subject.translate
        }.to raise_error(
          NameError, "Error: uninitialized constant PROJECT_UID in .env"
        )
      end

      it "raise NameError if ROOT_PATH_TO_SAVE is uninitialized in .env file" do
        allow(subject).to receive(:root_path_to_save).and_return(nil)

        expect {
          subject.translate
        }.to raise_error(
          NameError, "Error: uninitialized constant ROOT_PATH_TO_SAVE in .env"
        )
      end
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
        path_to_file: path_to_file,
        source_language_code: "en",
        conflict_mode: "replace"
      )

      expect(response.code).to eq(200)
      expect(response.body).to eq(body)
    end

    context "return errors" do
      it "raise NameError if APP_ID is uninitialized in .env file" do
        allow(subject).to receive(:app_id).and_return(nil)

        expect {
          subject.upload_file(
            path_to_file: path_to_file,
            source_language_code: "en",
            conflict_mode: "replace"
          )
        }.to raise_error(
          NameError, "Error: uninitialized constant APP_ID in .env"
        )
      end

      it "raise NameError if PRIVATE_KEY is uninitialized in .env file" do
        allow(subject).to receive(:private_key).and_return(nil)

        expect {
          subject.upload_file(
            path_to_file: path_to_file,
            source_language_code: "en",
            conflict_mode: "replace"
          )
        }.to raise_error(
          NameError, "Error: uninitialized constant PRIVATE_KEY in .env"
        )
      end

      it "raise NameError if PROJECT_UID is uninitialized in .env file" do
        allow(subject).to receive(:project_uid).and_return(nil)

        expect {
          subject.upload_file(
            path_to_file: path_to_file,
            source_language_code: "en",
            conflict_mode: "replace"
          )
        }.to raise_error(
          NameError, "Error: uninitialized constant PROJECT_UID in .env"
        )
      end

      it "raise NameError if ROOT_PATH_TO_SAVE is uninitialized in .env file" do
        allow(subject).to receive(:root_path_to_save).and_return(nil)

        expect {
          subject.upload_file(
            path_to_file: path_to_file,
            source_language_code: "en",
            conflict_mode: "replace"
          )
        }.to raise_error(
          NameError, "Error: uninitialized constant ROOT_PATH_TO_SAVE in .env"
        )
      end

      it "raise ArgumentError if file not found" do
        expect {
          subject.upload_file(
            path_to_file: './spec/support/no_file.en.yml',
            source_language_code: "en",
            conflict_mode: "replace"
          )
        }.to raise_error(
          ArgumentError, "Error: file not found"
        )
      end

      it "returns 500" do
        mocked_response = instance_double(HTTParty::Response, code: 500)
        allow(subject.class).to receive(:post).and_return(mocked_response)

        response = subject.upload_file(
          path_to_file: path_to_file,
          source_language_code: "en",
          conflict_mode: "replace"
        )
        expect(response.code).to eq(500)
      end
    end
  end
end
