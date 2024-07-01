require 'your_gem/config'

module LocalizeRubyClient
  class << self
    attr_accessor :config

    def configure
      self.config ||= Config.new
      yield(config)
    end
  end
end
