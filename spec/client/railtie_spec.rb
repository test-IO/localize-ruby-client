# frozen_string_literal: true

require "rake"

require_relative "../support/rails_mock"
require "client/railtie"

RSpec.describe Client::Railtie do
  before do
    # Create a new Rake application
    @rake = Rake::Application.new
    Rake.application = @rake

    # Ensure the load method is correctly stubbed and intercepted
    allow(Rake.application).to receive(:load).and_call_original
  end

  after do
    Rake.application = nil
  end

  it "loads rake tasks on gem install" do
    # Ensure the rake_tasks block is executed
    Client::Railtie.load_tasks
    # Verify that the rake tasks file was loaded
    expect(Rake.application.tasks.map(&:name)).to include("localize_ruby_client:upload_file")
    expect(Rake.application.tasks.map(&:name)).to include("localize_ruby_client:translate")
    expect(Rake.application.tasks.map(&:name)).to include("localize_ruby_client:update_translations")
    expect(Rake.application.tasks.map(&:name)).to include("localize_ruby_client:upload_and_translate_file")
  end
end
