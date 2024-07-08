# frozen_string_literal: true

require "client/version"

RSpec.describe Client do
  it "has a version number" do
    expect(Client::VERSION).not_to be_nil
  end
end
