require "log"
require "uri"
require "http"
require "json"

module Dorsum
  module Api
    class Authentication
      BASE_URL = "https://id.twitch.tv/oauth2/token"

      property config : Dorsum::Config
      property access_token : String
      property expires_in : Int32

      def initialize(@config)
        @access_token = ""
        @expires_in = 0
      end

      def run
        response = HTTP::Client.post(url)
        Log.info { "GET #{url} -> #{response.status_code}" }
        if response.status_code >= 200 && response.status_code < 300
          json = JSON.parse(response.body)
          self.access_token = json["access_token"].as_s
          self.expires_in = json["expires_in"].as_i
        end
      end

      def query
        query = URI::Params.new
        params.each do |name, value|
          query.add(name, value)
        end
        query.to_s
      end

      def url
        "#{BASE_URL}?#{query}"
      end

      def params
        {
          "client_id"     => @config.client_id.to_s,
          "client_secret" => @config.client_secret.to_s,
          "grant_type"    => "client_credentials",
        }
      end
    end
  end
end
