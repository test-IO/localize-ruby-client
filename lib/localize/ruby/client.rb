# frozen_string_literal: true

require_relative 'client/version'
require_relative 'client/translator'

module Localize
  module Ruby
    module Client
      def self.update_translations
        Translator.new.update_translations
      end

      def self.upload_file(file:, source_language_code:, conflict_mode:)
        Translator.new.upload_file(
          file: file,
          source_language_code: source_language_code,
          conflict_mode: conflict_mode
        )
      end

      def self.translate
        Translator.new.translate
      end
    end
  end
end
