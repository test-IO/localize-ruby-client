# frozen_string_literal: true

require "client/configuration_helper"

RSpec.describe Client::ConfigurationHelper do # rubocop:disable Metrics/BlockLength
  let(:dummy_class) do
    Class.new do
      include Client::ConfigurationHelper
    end
  end

  describe ".configure" do # rubocop:disable Metrics/BlockLength
    context "when configuration is valid" do
      it "sets the configuration and validates it" do
        dummy_class.configure do |config|
          config.app_id = "test_app_id"
          config.private_key = "test_private_key"
          config.project_uid = "123abc"
        end

        expect(dummy_class.config.app_id).to eq("test_app_id")
        expect(dummy_class.config.private_key).to eq("test_private_key")
        expect(dummy_class.config.project_uid).to eq("123abc")
      end
    end

    context "when configuration is invalid" do # rubocop:disable Metrics/BlockLength
      it "raises a NameError when required values are missing" do
        expect do
          dummy_class.configure do |config|
            config.app_id = nil
            config.private_key = nil
            config.project_uid = nil
          end
        end.to raise_error(NameError,
                           "Error: uninitialized configuration app_id, Error: uninitialized configuration private_key,"\
                           " Error: uninitialized configuration project_uid")
      end

      it "raises a NameError when app_id is missing" do
        expect do
          dummy_class.configure do |config|
            config.app_id = nil
            config.private_key = "test_private_key"
            config.project_uid = "123abc"
          end
        end.to raise_error(NameError, "Error: uninitialized configuration app_id")
      end

      it "raises a NameError when private_key is missing" do
        expect do
          dummy_class.configure do |config|
            config.app_id = "test_app_id"
            config.private_key = nil
            config.project_uid = "123abc"
          end
        end.to raise_error(NameError, "Error: uninitialized configuration private_key")
      end

      it "raises a NameError when project_uid is missing" do
        expect do
          dummy_class.configure do |config|
            config.app_id = "test_app_id"
            config.private_key = "test_private_key"
            config.project_uid = nil
          end
        end.to raise_error(NameError, "Error: uninitialized configuration project_uid")
      end
    end
  end
end
