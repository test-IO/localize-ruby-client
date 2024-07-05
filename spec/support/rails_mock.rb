# frozen_string_literal: true

# Mimic Rails and Railtie behavior
module Rails
  def self.root
    Pathname.new("spec/support/rails_app_mock")
  end

  class Railtie
    def self.rake_tasks(&block)
      @rake_tasks_blocks ||= []
      @rake_tasks_blocks << block
    end

    def self.load_tasks
      @rake_tasks_blocks.each(&:call)
    end
  end
end
