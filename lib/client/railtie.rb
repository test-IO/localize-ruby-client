require 'rails/railtie'

module Client
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/localize_ruby_client.rake'
    end
  end
end