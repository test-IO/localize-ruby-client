# frozen_string_literal: true

require "jwt"
require "active_support"
require "active_support/time"

module Client
  # The JwtHelper module provides a method to generate a JWT token.
  # The token is signed using the app's id and includes an expiration time.
  module JwtHelper
    def jwt_token
      payload = {
        exp: 10.minutes.from_now.to_i,
        iss: LocalizeRubyClient.config.app_id
      }

      JWT.encode(payload, LocalizeRubyClient.config.private_key, "HS256")
    end
  end
end
