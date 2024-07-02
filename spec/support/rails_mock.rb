# frozen_string_literal: true

# Mimic Railtie behavior on rake tasks load
module Rails
  class Railtie
    @rake_tasks_blocks = []

    def self.rake_tasks(&block)
      @rake_tasks_blocks ||= []
      @rake_tasks_blocks << block
    end

    def self.load_tasks
      @rake_tasks_blocks&.each(&:call)
    end
  end
end
