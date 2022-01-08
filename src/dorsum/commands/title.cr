require "log"
require "time"

module Dorsum
  module Commands
    class Title
      getter client : Dorsum::Client
      getter api : Dorsum::Api::Client
      getter broadcaster_id : String

      def initialize(@client, @api, @broadcaster_id)
      end

      def run(message)
        return unless message.message

        content = message.message.as(String)
        if content.starts_with?("!title")
          channel = @api.channel(broadcaster_id)
          return unless channel

          title = channel["title"].as_s
          return unless title

          client.puts("PRIVMSG #{message.arguments} :@#{message.display_name} #{title}")
        end

        if content.starts_with?("!game")
          channel = @api.channel(broadcaster_id)
          return unless channel

          game_name = channel["game_name"].as_s
          return unless game_name

          client.puts("PRIVMSG #{message.arguments} :@#{message.display_name} #{game_name}")
        end
      end
    end
  end
end
