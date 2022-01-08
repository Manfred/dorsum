require "log"
require "time"

module Dorsum
  module Commands
    class Title
      COOLDOWN = Time::Span.new(seconds: 90)

      getter client : Dorsum::Client
      getter api : Dorsum::Api::Client
      getter broadcaster_id : String

      getter last : Time::Span

      def initialize(@client, @api, @broadcaster_id)
        @last = Time.monotonic - COOLDOWN
      end

      def run(message)
        return unless message.message

        content = message.message.as(String)
        if content.starts_with?("!title")
          return if cooldown?

          channel = api.channel(broadcaster_id)
          return unless channel

          title = channel["title"].as_s
          return unless title

          title = title.empty? ? "no title right now…" : title
          client.puts("PRIVMSG #{message.arguments} :@#{message.display_name} MrDestructoid #{title}")
        end

        if content.starts_with?("!game")
          return if cooldown?

          channel = api.channel(broadcaster_id)
          return unless channel

          game_name = channel["game_name"].as_s
          return unless game_name

          game_name = game_name.empty? ? "no game right now…" : game_name
          client.puts("PRIVMSG #{message.arguments} :@#{message.display_name} MrDestructoid #{game_name}")
        end
      end

      private def since
        Time.monotonic - last
      end

      private def on_cooldown?
        since < COOLDOWN
      end

      private def cooldown?
        if on_cooldown?
          Log.info { "Cooldown #{Dorsum::Message.formatted_time_span(since)}" }
          true
        else
          @last = Time.monotonic
          false
        end
      end
    end
  end
end
