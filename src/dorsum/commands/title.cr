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
          game_name = channel["game_name"].as_s
          return unless title && game_name

          reply = "#{title}"
          reply = "#{reply}, playing ‘#{game_name}’" unless game_name.empty?

          client.puts("PRIVMSG #{message.arguments} :@#{message.display_name} #{reply}")
        end
      end
    end
  end
end
