require_relative 'config'

module Client
  module ConfigurationHelper
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :config

      def configure
        self.config ||= Config.new
        yield(config)
        self.config.validate!
      end
    end
  end
end

