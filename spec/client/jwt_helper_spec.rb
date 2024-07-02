# frozen_string_literal: true

require "client/jwt_helper"
require "client/config"

RSpec.describe Client::JwtHelper do
  let(:dummy_class) do
    Class.new do
      include Client::JwtHelper
    end
  end

  let(:instance) { dummy_class.new }
  let(:config) { Client::Config.new }

  before do
    allow(LocalizeRubyClient).to receive(:config).and_return(config)
    config.app_id = "test_app_id"
    config.private_key = "test_private_key"
  end

  describe "#jwt_token" do
    it "generates a JWT token with the correct payload and signature" do
      token = instance.jwt_token
      decoded_token = JWT.decode(token, config.private_key, true, { algorithm: "HS256" })

      payload = decoded_token.first
      header = decoded_token.last

      expect(payload["iss"]).to eq("test_app_id")
      expect(payload["exp"]).to be_within(5).of(10.minutes.from_now.to_i)
      expect(header["alg"]).to eq("HS256")
    end
  end
end
