# frozen_string_literal: true

module Client
  # This class integrates the gem with a Rails application if Rails is present.
  # It automatically loads rake tasks provided by the gem.
  class Railtie < Rails::Railtie
    rake_tasks do
      load "lib/tasks/localize_ruby_client.rake"
    end
  end
end
