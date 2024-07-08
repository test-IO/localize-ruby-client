# frozen_string_literal: true

require "client/config"

RSpec.describe Client::Config do # rubocop:disable Metrics/BlockLength
  let(:config) { Client::Config.new }

  describe "#initialize" do
    it "initializes with default values" do
      expect(config.app_id).to be_nil
      expect(config.private_key).to be_nil
      expect(config.project_uid).to be_nil
      expect(config.locales_dir_path).to eq(Rails.root.join("config", "locales").to_s)
      expect(config.site).to eq("https://localize.cirro.io/api")
      expect(config.api_version).to eq("v2")
    end
  end

  describe "#validate!" do # rubocop:disable Metrics/BlockLength
    context "when all required attributes are set" do
      before do
        config.app_id = "test_app_id"
        config.private_key = "test_private_key"
        config.project_uid = "123abc"
      end

      it "does not raise any error" do
        expect { config.validate! }.not_to raise_error
      end
    end

    context "when required attributes are missing" do
      it "raises a NameError with appropriate message" do
        expect do
          config.validate!
        end.to raise_error(NameError,
                           "Error: uninitialized configuration app_id, Error: uninitialized configuration private_key,"\
                           " Error: uninitialized configuration project_uid")
      end

      it "raises a NameError when app_id is missing" do
        config.private_key = "test_private_key"
        config.project_uid = "123abc"
        expect { config.validate! }.to raise_error(NameError, "Error: uninitialized configuration app_id")
      end

      it "raises a NameError when private_key is missing" do
        config.app_id = "test_app_id"
        config.project_uid = "123abc"
        expect { config.validate! }.to raise_error(NameError, "Error: uninitialized configuration private_key")
      end

      it "raises a NameError when locales_dir_path is missing" do
        config.app_id = "test_app_id"
        config.private_key = "test_private_key"
        expect { config.validate! }.to raise_error(NameError, "Error: uninitialized configuration project_uid")
      end
    end
  end
end
