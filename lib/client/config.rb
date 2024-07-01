module Client
  class Config
    attr_accessor :app_id, :private_key, :root_path_to_save, :site, :api_version

    def initialize
      @app_id = nil
      @private_key = nil
      @root_path_to_save = nil
      @site = 'https://localize.cirro.io/api'
      @api_version = 'v2'
    end

    def validate!
      credentials = {
        app_id: @app_id,
        private_key: @private_key,
        root_path_to_save: @root_path_to_save
      }

      messages = credentials.map do |variable_name, value|
        "Error: uninitialized constant #{variable_name.upcase} in .env" if value.nil? || value.strip.empty?
      end.compact

      raise NameError, messages.join(', ') if messages.present?
    end
  end
end